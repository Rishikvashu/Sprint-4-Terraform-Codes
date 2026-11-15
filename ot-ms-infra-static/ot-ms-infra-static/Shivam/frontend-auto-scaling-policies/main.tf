# Ticket: Frontend - Auto Scaling Policies
# Target tracking: keep average CPU near 60%. (Scaling policies cannot be tagged by AWS.)
# Cost-allocation tags: Application=frontend Owner=Shivam Environment=dev CostCenter=CC-OT-DEV-1001

data "aws_autoscaling_group" "main" {
  name = "ot-ms-dev-frontend-asg"
}

resource "aws_autoscaling_policy" "cpu" {
  name                   = "ot-ms-dev-frontend-cpu-target-tracking"
  autoscaling_group_name = data.aws_autoscaling_group.main.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    target_value = 60

    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
}

output "policy_arn" {
  value = aws_autoscaling_policy.cpu.arn
}
