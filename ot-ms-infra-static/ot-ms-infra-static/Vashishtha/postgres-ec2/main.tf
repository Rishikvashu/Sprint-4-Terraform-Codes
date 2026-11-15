# Ticket: Postgres - EC2
# DB container on a private-db instance with a separate encrypted data disk. Dev password is 'password' (same as the app configs) - change for anything real.

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-vpc"]
  }
}

data "aws_subnet" "private_db_a" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-private-db-a"]
  }
}

data "aws_security_group" "db" {
  name   = "ot-ms-dev-postgres-sg"
  vpc_id = data.aws_vpc.main.id
}

# Latest Amazon Linux 2023 AMI (AWS keeps this SSM parameter up to date)
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# IAM role so the instance can be reached with SSM Session Manager (no SSH port needed)
resource "aws_iam_role" "this" {
  name = "ot-ms-dev-postgres-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = {
    Name        = "ot-ms-dev-postgres-role"
    Application = "postgres"
    Owner       = "Vashishtha"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "ot-ms-dev-postgres-instance-profile"
  role = aws_iam_role.this.name

  tags = {
    Name        = "ot-ms-dev-postgres-instance-profile"
    Application = "postgres"
    Owner       = "Vashishtha"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_instance" "main" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = "t3.medium"
  subnet_id              = data.aws_subnet.private_db_a.id
  vpc_security_group_ids = [data.aws_security_group.db.id]
  key_name               = "ot-ms-dev-key"
  iam_instance_profile   = aws_iam_instance_profile.this.name

  user_data                   = <<-EOT
    #!/bin/bash
    set -euo pipefail
    dnf install -y docker xfsprogs
    systemctl enable --now docker

    # wait for the data disk, format it once and mount it
    while [ ! -b /dev/nvme1n1 ]; do sleep 2; done
    blkid /dev/nvme1n1 || mkfs -t xfs /dev/nvme1n1
    mkdir -p /data
    mount /dev/nvme1n1 /data
    mkdir -p /data/postgres

    docker run -d --name postgres --restart always -p 5432:5432 -v /data/postgres:/var/lib/postgresql/data -e POSTGRES_PASSWORD=password -e POSTGRES_DB=attendance_db postgres:15
  EOT
  user_data_replace_on_change = true

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_type = "gp3"
    volume_size = 30
    encrypted   = true
  }

  tags = {
    Name        = "ot-ms-dev-postgres"
    Application = "postgres"
    Owner       = "Vashishtha"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

output "private_ip" {
  value = aws_instance.main.private_ip
}
