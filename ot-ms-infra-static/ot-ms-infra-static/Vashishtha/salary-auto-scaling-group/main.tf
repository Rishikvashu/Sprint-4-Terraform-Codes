# Ticket: Salary - Auto Scaling Group
# 1 to 2 instances across both private-app subnets, ELB health checks, rolling instance refresh.

data "aws_subnet" "private_app_a" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-private-app-a"]
  }
}

data "aws_subnet" "private_app_b" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-private-app-b"]
  }
}

data "aws_launch_template" "main" {
  name = "ot-ms-dev-salary-lt"
}

data "aws_lb_target_group" "main" {
  name = "ot-ms-dev-salary-tg"
}

resource "aws_autoscaling_group" "main" {
  name                      = "ot-ms-dev-salary-asg"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  vpc_zone_identifier       = [data.aws_subnet.private_app_a.id, data.aws_subnet.private_app_b.id]
  target_group_arns         = [data.aws_lb_target_group.main.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = data.aws_launch_template.main.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = "ot-ms-dev-salary"
    propagate_at_launch = true
  }

  tag {
    key                 = "Application"
    value               = "salary"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "Vashishtha"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "dev"
    propagate_at_launch = true
  }

  tag {
    key                 = "CostCenter"
    value               = "CC-OT-DEV-1001"
    propagate_at_launch = true
  }

  lifecycle {
    # the scaling policy changes desired capacity at runtime
    ignore_changes = [desired_capacity]
  }
}

output "asg_name" {
  value = aws_autoscaling_group.main.name
}
