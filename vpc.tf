provider "aws" {
  region = "us-east-1"
}
# creating vpc
resource aws_vpc "cloudforce_vpc"{
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "cloudforce_vpc"
  }
}
# creating public subnet 1
resource aws_subnet "cloudforce_publicA" {
  vpc_id = aws_vpc.cloudforce_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "cloudforce_publicA"
  }
}
# creating private subnet 1
resource aws_subnet "cloudforce_privateA"{
  vpc_id = aws_vpc.cloudforce_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "cloudforce_privateA"
  }
}
# creating public subnet 2
resource aws_subnet "cloudforce_publicB"{
  vpc_id = aws_vpc.cloudforce_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "cloudforce_publicB"
  }
}
# creating private subnet 2
resource aws_subnet "cloudforce_privateB"{
  vpc_id = aws_vpc.cloudforce_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "cloudforce_privateB"
  }
}
# creating an internet gateway
resource "aws_internet_gateway" "cloudforce_igw" {
  vpc_id = aws_vpc.cloudforce_vpc.id

  tags = {
    "Name" = "cloudforce_igw"
  }
}
# creating a route table 
resource "aws_route_table" "cloudforce_rtb" {
  vpc_id = aws_vpc.cloudforce_vpc.id

  tags = {
    "Name" = "cloudforce_rtb"
  }
}
# creating a route
resource "aws_route" "cloudforce_rt" {
  route_table_id = aws_route_table.cloudforce_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.cloudforce_igw.id

}
# associating the route table to public subnet 1
resource "aws_route_table_association" "cloudforce_rtb_assoc1" {
  subnet_id = aws_subnet.cloudforce_publicA.id
  route_table_id = aws_route_table.cloudforce_rtb.id
}
# associating the route table to public subnet 2
resource "aws_route_table_association" "cloudforce_rtb_assoc2" {
  subnet_id = aws_subnet.cloudforce_publicB.id
  route_table_id = aws_route_table.cloudforce_rtb.id
}
# creating an elastic IP for a NAT gateway
resource "aws_eip" "Nat-Gateway-EIP" {
  depends_on = [
    aws_route_table_association.cloudforce_rtb_assoc1
  ]
  vpc = true
}
# Creating a NAT gateway in public subnet 1
resource "aws_nat_gateway" "cloudNAT" {
  depends_on = [
    aws_eip.Nat-Gateway-EIP
  ]

  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.Nat-Gateway-EIP.id
  
  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.cloudforce_publicA.id
  tags = {
    Name = "NAT gateway 1"
  }
}

# Creating a Route Table for the Nat Gateway 
resource "aws_route_table" "NAT-Gateway-RT" {
  depends_on = [
    aws_nat_gateway.cloudNAT
  ]

  vpc_id = aws_vpc.cloudforce_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cloudNAT.id
  }

  tags = {
    Name = "Route Table for NAT Gateway"
  }

}


# Associating route table for NAT gateway to public subnet A
resource "aws_route_table_association" "Nat-Gateway-RT-AssociationA" {
  depends_on = [
    aws_route_table.NAT-Gateway-RT
  ]

#  Private Subnet ID for adding this route table to the DHCP server of Private subnet!
  subnet_id      = aws_subnet.cloudforce_privateA.id

# Route Table ID
  route_table_id = aws_route_table.NAT-Gateway-RT.id
}

# Associating route table for NAT gateway to public subnet B
resource "aws_route_table_association" "Nat-Gateway-RT-AssociationB" {
  depends_on = [
    aws_route_table.NAT-Gateway-RT
  ]

#  Private Subnet ID for adding this route table to the DHCP server of Private subnet!
  subnet_id      = aws_subnet.cloudforce_privateB.id

# Route Table ID
  route_table_id = aws_route_table.NAT-Gateway-RT.id
}
