# Ticket: Attendance - Target Group
# Health check on /api/v1/attendance/health

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-vpc"]
  }
}

resource "aws_lb_target_group" "main" {
  name                 = "ot-ms-dev-attendance-tg"
  port                 = 8080
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = data.aws_vpc.main.id
  deregistration_delay = 30

  health_check {
    path                = "/api/v1/attendance/health"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "ot-ms-dev-attendance-tg"
    Application = "attendance"
    Owner       = "Anshul"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}
