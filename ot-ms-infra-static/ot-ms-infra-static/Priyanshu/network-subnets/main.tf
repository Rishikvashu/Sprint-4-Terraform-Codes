# Ticket: Terraform static code to configure Subnets
# 2 public (ALB + NAT), 2 private-app (apps), 2 private-db (databases) across ap-south-1a/1b.

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-vpc"]
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "ot-ms-dev-public-a"
    Tier        = "public"
    Application = "network"
    Owner       = "Priyanshu"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "ot-ms-dev-public-b"
    Tier        = "public"
    Application = "network"
    Owner       = "Priyanshu"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_subnet" "private_app_a" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "ot-ms-dev-private-app-a"
    Tier        = "private-app"
    Application = "network"
    Owner       = "Priyanshu"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_subnet" "private_app_b" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false

  tags = {
    Name        = "ot-ms-dev-private-app-b"
    Tier        = "private-app"
    Application = "network"
    Owner       = "Priyanshu"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_subnet" "private_db_a" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = "10.0.21.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "ot-ms-dev-private-db-a"
    Tier        = "private-db"
    Application = "network"
    Owner       = "Priyanshu"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_subnet" "private_db_b" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = "10.0.22.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false

  tags = {
    Name        = "ot-ms-dev-private-db-b"
    Tier        = "private-db"
    Application = "network"
    Owner       = "Priyanshu"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}
