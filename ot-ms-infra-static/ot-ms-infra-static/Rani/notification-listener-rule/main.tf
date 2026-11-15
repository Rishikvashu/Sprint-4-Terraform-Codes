# Ticket: Notification - Listener rule of ALB
# Path /api/v1/notification* -> notification target group (priority 140).

data "aws_lb" "main" {
  name = "ot-ms-dev-alb"
}

data "aws_lb_listener" "http" {
  load_balancer_arn = data.aws_lb.main.arn
  port              = 80
}

data "aws_lb_target_group" "main" {
  name = "ot-ms-dev-notification-tg"
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = data.aws_lb_listener.http.arn
  priority     = 140

  action {
    type             = "forward"
    target_group_arn = data.aws_lb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = ["/api/v1/notification*"]
    }
  }

  tags = {
    Name        = "ot-ms-dev-notification-rule"
    Application = "notification"
    Owner       = "Rani"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

output "listener_rule_arn" {
  value = aws_lb_listener_rule.main.arn
}
