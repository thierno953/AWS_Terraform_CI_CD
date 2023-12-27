resource "aws_vpc" "tmbVPC" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name    = "tmbVPC"
    Project = "TMB TF Project"
  }
}

resource "aws_internet_gateway" "tmbIGW" {
  vpc_id = aws_vpc.tmbVPC.id
  tags = {
    Name    = "tmbIGW"
    Project = "TMB TF Project"
  }
}

resource "aws_eip" "tmbNatGatewayEIP1" {
  tags = {
    Name    = "tmbNatGatewayEIP1"
    Project = "TMB TF Project"
  }
}
resource "aws_nat_gateway" "tmbNatGateway1" {
  allocation_id = aws_eip.tmbNatGatewayEIP1.id
  subnet_id     = aws_subnet.tmbPublicSubnet1.id
  tags = {
    Name    = "tmbNatGateway1"
    Project = "TMB TF Project"
  }
}
resource "aws_subnet" "tmbPublicSubnet1" {
  vpc_id            = aws_vpc.tmbVPC.id
  cidr_block        = var.public_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]
  tags = {
    Name    = "tmbPublicSubnet1"
    Project = "TMB TF Project"
  }
}

resource "aws_eip" "tmbNatGatewayEIP2" {
  tags = {
    Name    = "tmbNatGatewayEIP2"
    Project = "TMB TF Project"
  }
}
resource "aws_nat_gateway" "tmbNatGateway2" {
  allocation_id = aws_eip.tmbNatGatewayEIP2.id
  subnet_id     = aws_subnet.tmbPublicSubnet1.id
  tags = {
    Name    = "tmbNatGateway2"
    Project = "TMB TF Project"
  }
}
resource "aws_subnet" "tmbPublicSubnet2" {
  vpc_id            = aws_vpc.tmbVPC.id
  cidr_block        = var.public_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]
  tags = {
    Name    = "tmbPublicSubnet2"
    Project = "TMB TF Project"
  }
}

resource "aws_subnet" "tmbPrivateSubnet1" {
  vpc_id            = aws_vpc.tmbVPC.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]
  tags = {
    Name    = "tmbPrivateSubnet1"
    Project = "TMB TF Project"
  }
}
resource "aws_subnet" "tmbPrivateSubnet2" {
  vpc_id            = aws_vpc.tmbVPC.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]
  tags = {
    Name    = "tmbPrivateSubnet2"
    Project = "TMB TF Project"
  }
}

resource "aws_route_table" "tmbPublicRT" {
  vpc_id = aws_vpc.tmbVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tmbIGW.id
  }
  tags = {
    Name    = "tmbPublicRT"
    Project = "TMB TF Project"
  }
}
resource "aws_route_table" "tmbPrivateRT1" {
  vpc_id = aws_vpc.tmbVPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tmbNatGateway1.id
  }
  tags = {
    Name    = "tmbPrivateRT1"
    Project = "TMB TF Project"
  }
}
resource "aws_route_table" "tmbPrivateRT2" {
  vpc_id = aws_vpc.tmbVPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tmbNatGateway2.id
  }
  tags = {
    Name    = "tmbPrivateRT2"
    Project = "TMB TF Project"
  }
}

resource "aws_route_table_association" "tmbPublicRTassociation1" {
  subnet_id      = aws_subnet.tmbPublicSubnet1.id
  route_table_id = aws_route_table.tmbPublicRT.id
}
resource "aws_route_table_association" "tmbPublicRTassociation2" {
  subnet_id      = aws_subnet.tmbPublicSubnet2.id
  route_table_id = aws_route_table.tmbPublicRT.id
}
resource "aws_route_table_association" "tmbPrivateRTassociation1" {
  subnet_id      = aws_subnet.tmbPrivateSubnet1.id
  route_table_id = aws_route_table.tmbPrivateRT1.id
}
resource "aws_route_table_association" "tmbPrivateRTassociation2" {
  subnet_id      = aws_subnet.tmbPrivateSubnet2.id
  route_table_id = aws_route_table.tmbPrivateRT2.id
}
