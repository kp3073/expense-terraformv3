resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "public_subent" {
  count = length(var.public_subent)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subent[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "public-subnet-${count.index+1}"
  }
}

resource "aws_subnet" "private_subent" {
  count = length(var.private_subent)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subent[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private-subnet-${count.index+1}"

  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_eip" "ngw" {
  domain   = "vpc"
}


resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public_subent[0].id

  tags = {
    Name = "${var.env}-ngw"
  }
}

resource "aws_vpc_peering_connection" "foo" {
  peer_owner_id = var.account_no
  peer_vpc_id   = aws_vpc.default_vpc_id.id
  vpc_id        = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.ngw.id
  }
  tags = {
    Name = "private"
  }
}