# Ticket: Terraform static code to configure NACL rules
# One NACL per tier. Ports 1024-65535 are open inbound for return traffic (NACLs are stateless).

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

resource "aws_network_acl" "public" {
  vpc_id = data.aws_vpc.main.id

  subnet_ids = [
    data.aws_subnet.public_a.id,
    data.aws_subnet.public_b.id,
  ]

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    rule_no    = 200
    action     = "allow"
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    rule_no    = 300
    action     = "allow"
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  # NACLs are stateless: all outbound allowed, inbound is whitelisted above
  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    from_port  = 0
    to_port    = 0
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name        = "ot-ms-dev-public-nacl"
    Application = "network"
    Owner       = "Vashishtha"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_network_acl" "private_app" {
  vpc_id = data.aws_vpc.main.id

  subnet_ids = [
    data.aws_subnet.private_app_a.id,
    data.aws_subnet.private_app_b.id,
  ]

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    from_port  = 3000
    to_port    = 3000
    cidr_block = "10.0.0.0/16"
  }

  ingress {
    rule_no    = 200
    action     = "allow"
    protocol   = "tcp"
    from_port  = 8080
    to_port    = 8080
    cidr_block = "10.0.0.0/16"
  }

  ingress {
    rule_no    = 300
    action     = "allow"
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  # NACLs are stateless: all outbound allowed, inbound is whitelisted above
  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    from_port  = 0
    to_port    = 0
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name        = "ot-ms-dev-private-app-nacl"
    Application = "network"
    Owner       = "Vashishtha"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

resource "aws_network_acl" "private_db" {
  vpc_id = data.aws_vpc.main.id

  subnet_ids = [
    data.aws_subnet.private_db_a.id,
    data.aws_subnet.private_db_b.id,
  ]

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    from_port  = 5432
    to_port    = 5432
    cidr_block = "10.0.0.0/16"
  }

  ingress {
    rule_no    = 200
    action     = "allow"
    protocol   = "tcp"
    from_port  = 6379
    to_port    = 6379
    cidr_block = "10.0.0.0/16"
  }

  ingress {
    rule_no    = 300
    action     = "allow"
    protocol   = "tcp"
    from_port  = 9042
    to_port    = 9042
    cidr_block = "10.0.0.0/16"
  }

  ingress {
    rule_no    = 400
    action     = "allow"
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  # NACLs are stateless: all outbound allowed, inbound is whitelisted above
  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    from_port  = 0
    to_port    = 0
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name        = "ot-ms-dev-private-db-nacl"
    Application = "network"
    Owner       = "Vashishtha"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}
