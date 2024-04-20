# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "example_public" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "example_public_1" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "example_public_2" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "example_public_3" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.region}c"

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "example_public_1" {
  subnet_id      = aws_subnet.example_public_1.id
  route_table_id = aws_route_table.example_public.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "example_public_2" {
  subnet_id      = aws_subnet.example_public_2.id
  route_table_id = aws_route_table.example_public.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "example_public_3" {
  subnet_id      = aws_subnet.example_public_3.id
  route_table_id = aws_route_table.example_public.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
resource "aws_db_subnet_group" "example_public" {
  name       = local.project_name
  subnet_ids = [aws_subnet.example_public_1.id, aws_subnet.example_public_2.id, aws_subnet.example_public_3.id]

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "example_vpc_link" {
  name   = "${var.project}-vpc-link-${var.env}"
  vpc_id = aws_vpc.example.id

  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      description      = "Internal from API Gateway"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "example_api" {
  name   = "${var.project}-api-${var.env}"
  vpc_id = aws_vpc.example.id

  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  ingress = [
    {
      cidr_blocks      = []
      description      = "Internal from ${aws_security_group.example_vpc_link.name}"
      from_port        = var.app_port
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = [aws_security_group.example_vpc_link.id]
      self             = false
      to_port          = var.app_port
    }
  ]

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "example_postgres" {
  name   = "${var.project}-postgres-${var.env}"
  vpc_id = aws_vpc.example.id

  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  ingress = [
    {
      cidr_blocks      = []
      description      = "Internal from ${aws_security_group.example_api.name}"
      from_port        = var.db_port
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = [aws_security_group.example_api.id]
      self             = false
      to_port          = var.db_port
    }
  ]

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}
