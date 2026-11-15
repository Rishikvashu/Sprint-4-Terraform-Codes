# Ticket: Terraform static code to configure IGW

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-vpc"]
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name        = "ot-ms-dev-igw"
    Application = "network"
    Owner       = "Sarthak"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

output "igw_id" {
  value = aws_internet_gateway.main.id
}
