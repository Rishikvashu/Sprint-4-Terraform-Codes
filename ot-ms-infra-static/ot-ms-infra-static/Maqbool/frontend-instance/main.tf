# Ticket: Frontend - Instance
# One dev EC2 in private-app-a running the container, reachable with SSM (IMDSv2, encrypted disk).

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-vpc"]
  }
}

data "aws_subnet" "private_app_a" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-private-app-a"]
  }
}

data "aws_security_group" "app" {
  name   = "ot-ms-dev-frontend-sg"
  vpc_id = data.aws_vpc.main.id
}

# Latest Amazon Linux 2023 AMI (AWS keeps this SSM parameter up to date)
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# IAM role so the instance can be reached with SSM Session Manager (no SSH port needed)
resource "aws_iam_role" "this" {
  name = "ot-ms-dev-frontend-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = {
    Name        = "ot-ms-dev-frontend-role"
    Application = "frontend"
    Owner       = "Maqbool"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "ot-ms-dev-frontend-instance-profile"
  role = aws_iam_role.this.name

  tags = {
    Name        = "ot-ms-dev-frontend-instance-profile"
    Application = "frontend"
    Owner       = "Maqbool"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_instance" "main" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = "t3.small"
  subnet_id              = data.aws_subnet.private_app_a.id
  vpc_security_group_ids = [data.aws_security_group.app.id]
  key_name               = "ot-ms-dev-key"
  iam_instance_profile   = aws_iam_instance_profile.this.name

  user_data                   = <<-EOT
    #!/bin/bash
    set -euo pipefail
    dnf install -y docker
    systemctl enable --now docker
    docker run -d --name frontend --restart always -p 3000:3000 quay.io/opstree/frontend-app:latest
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

  tags = {
    Name        = "ot-ms-dev-frontend-instance"
    Application = "frontend"
    Owner       = "Maqbool"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

output "instance_id" {
  value = aws_instance.main.id
}
