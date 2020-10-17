provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "terraformvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.terraformvpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "terraform_public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.terraformvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "terraform_private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terraformvpc.id

  tags = {
    Name = "terraform_igw"
  }
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.terraformvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "terraform_igw"
  }
}

resource "aws_route_table_association" "asso1" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "asso2" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.RT.id
}
