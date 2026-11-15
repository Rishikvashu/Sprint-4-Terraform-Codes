# Ticket: Terraform static code to configure route tables
# Public route table -> IGW, private route table -> NAT.

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-vpc"]
  }
}

data "aws_internet_gateway" "main" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.main.id]
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

data "aws_subnet" "private_db_a" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-private-db-a"]
  }
}

data "aws_subnet" "private_db_b" {
  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-private-db-b"]
  }
}

data "aws_nat_gateway" "main" {
  vpc_id = data.aws_vpc.main.id
  state  = "available"

  filter {
    name   = "tag:Name"
    values = ["ot-ms-dev-nat"]
  }
}

resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name        = "ot-ms-dev-public-rt"
    Application = "network"
    Owner       = "Shivam"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.main.id
}

resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name        = "ot-ms-dev-private-rt"
    Application = "network"
    Owner       = "Shivam"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = data.aws_nat_gateway.main.id
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = data.aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = data.aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_app_a" {
  subnet_id      = data.aws_subnet.private_app_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_app_b" {
  subnet_id      = data.aws_subnet.private_app_b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db_a" {
  subnet_id      = data.aws_subnet.private_db_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db_b" {
  subnet_id      = data.aws_subnet.private_db_b.id
  route_table_id = aws_route_table.private.id
}
