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
    Name = "public-subent-${count.index+1}"
  }
}

resource "aws_subnet" "private_subent" {
  count = length(var.private_subent)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subent[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private-subent-${count.index+1}"

  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_eip" "eip" {
  domain   = "vpc"
}