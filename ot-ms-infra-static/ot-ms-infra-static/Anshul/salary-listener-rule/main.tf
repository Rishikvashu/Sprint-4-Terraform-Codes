# Ticket: Salary - Listener rule of ALB
# Path /api/v1/salary* -> salary target group (priority 130).

data "aws_lb" "main" {
  name = "ot-ms-dev-alb"
}

data "aws_lb_listener" "http" {
  load_balancer_arn = data.aws_lb.main.arn
  port              = 80
}

data "aws_lb_target_group" "main" {
  name = "ot-ms-dev-salary-tg"
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = data.aws_lb_listener.http.arn
  priority     = 130

  action {
    type             = "forward"
    target_group_arn = data.aws_lb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = ["/api/v1/salary*"]
    }
  }

  tags = {
    Name        = "ot-ms-dev-salary-rule"
    Application = "salary"
    Owner       = "Anshul"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

output "listener_rule_arn" {
  value = aws_lb_listener_rule.main.arn
}
