# Ticket: Postgres - security group
# Only the app security groups (attendance) can connect on port 5432. No CIDR ingress, nothing open to the world.
# Deploy AFTER those app security-group stacks exist.

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-vpc"]
  }
}

data "aws_security_group" "attendance_app" {
  name   = "ot-ms-dev-attendance-sg"
  vpc_id = data.aws_vpc.main.id
}

resource "aws_security_group" "db" {
  name        = "ot-ms-dev-postgres-sg"
  description = "Postgres security group"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description     = "Postgres port from app security groups only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [data.aws_security_group.attendance_app.id]
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
    Name        = "ot-ms-dev-postgres-sg"
    Application = "postgres"
    Owner       = "Rani"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

output "security_group_id" {
  value = aws_security_group.db.id
}
