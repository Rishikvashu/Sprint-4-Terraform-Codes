# Ticket: Terraform static code to configure Route_53
# Hosted zone + app/api alias records pointing to the ALB.

data "aws_lb" "main" {
  name = "ot-ms-dev-alb"
}

resource "aws_route53_zone" "main" {
  name = "dev.ot-microservices.example.com"

  tags = {
    Name        = "ot-ms-dev-zone"
    Application = "network"
    Owner       = "Anurag"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.dev.ot-microservices.example.com"
  type    = "A"

  alias {
    name                   = data.aws_lb.main.dns_name
    zone_id                = data.aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.dev.ot-microservices.example.com"
  type    = "A"

  alias {
    name                   = data.aws_lb.main.dns_name
    zone_id                = data.aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

output "name_servers" {
  value = aws_route53_zone.main.name_servers
}
