# Ticket: Syclla DB - security group
# Only the app security groups (employee, salary) can connect on port 9042. No CIDR ingress, nothing open to the world.
# Deploy AFTER those app security-group stacks exist.

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-vpc"]
  }
}

data "aws_security_group" "employee_app" {
  name   = "ot-ms-dev-employee-sg"
  vpc_id = data.aws_vpc.main.id
}

data "aws_security_group" "salary_app" {
  name   = "ot-ms-dev-salary-sg"
  vpc_id = data.aws_vpc.main.id
}

resource "aws_security_group" "db" {
  name        = "ot-ms-dev-scylladb-sg"
  description = "Syclla DB security group"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description     = "Syclla DB port from app security groups only"
    from_port       = 9042
    to_port         = 9042
    protocol        = "tcp"
    security_groups = [data.aws_security_group.employee_app.id, data.aws_security_group.salary_app.id]
  }

  egress {
    description = "HTTP out (image pull)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTPS out (image pull)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ot-ms-dev-scylladb-sg"
    Application = "scylladb"
    Owner       = "Maqbool"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

output "security_group_id" {
  value = aws_security_group.db.id
}
