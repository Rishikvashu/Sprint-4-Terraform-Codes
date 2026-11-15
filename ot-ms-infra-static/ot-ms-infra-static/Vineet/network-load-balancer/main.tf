# Ticket: Terraform static code to configure Load balancer
# Public ALB on HTTP :80. Default answer is 404; every app adds its own path based listener rule.

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-vpc"]
  }
}

data "aws_subnet" "public_a" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-public-a"]
  }
}

data "aws_subnet" "public_b" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-public-b"]
  }
}

resource "aws_security_group" "alb" {
  name        = "ot-ms-dev-alb-sg"
  description = "Public ALB security group"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "To frontend"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "To APIs"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name        = "ot-ms-dev-alb-sg"
    Application = "network"
    Owner       = "Vineet"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_lb" "main" {
  name                       = "ot-ms-dev-alb"
  load_balancer_type         = "application"
  internal                   = false
  security_groups            = [aws_security_group.alb.id]
  subnets                    = [data.aws_subnet.public_a.id, data.aws_subnet.public_b.id]
  drop_invalid_header_fields = true

  tags = {
    Name        = "ot-ms-dev-alb"
    Application = "network"
    Owner       = "Vineet"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "no route matched"
      status_code  = "404"
    }
  }

  tags = {
    Name        = "ot-ms-dev-alb-http"
    Application = "network"
    Owner       = "Vineet"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}
