# create VPC to launch EC2 instance
resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
      Name = "nagios-vpc"
    }
}

# Grab the list of availability zones
data "aws_availability_zones" "available" {}

# Create public subnet
resource "aws_subnet" "public_subnet" { 
  count                   = 2
  cidr_block              = "${var.public_subnet_cidrs[count.index]}"
  vpc_id                  = "${aws_vpc.my_vpc.id}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "nagios-public-subnet.${count.index + 1}"
  }
}

# Create private subnet
resource "aws_subnet" "private_subnet" {
  count             = 2
  cidr_block        = "${var.private_subnet_cidrs[count.index]}"
  vpc_id            = "${aws_vpc.my_vpc.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "nagios-private-subnet.${count.index + 1}"
  }
}

# create an Internet Gateway(IGW) to give subnets access to the outside world
# Internet gateway is a horizontally scaled, redundant and highly avilable VPC component.
# Internet gateway serves one more purpose, it performs NAT for instances that have been assigned public IPv4 addresses.
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags = {
    Name = "nagios-igw"
  }
}
# Create public subnet route table(assosiated with igw)
resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  route {
    cidr_block = var.igw_cidr
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "nagios-public-route"
  }
}
# Create private subnet route table
resource "aws_default_route_table" "private_route" {
  default_route_table_id = "${aws_vpc.my_vpc.default_route_table_id}"

  tags = {   
    Name = "nagios-private-route-table"
  } 
}   

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = 2
  route_table_id = "${aws_route_table.public_route.id}"
  subnet_id      = "${aws_subnet.public_subnet.*.id[count.index]}"
  depends_on     = ["aws_route_table.public_route", "aws_subnet.public_subnet"]
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_subnet_assoc" {
  count          = 2
  route_table_id = "${aws_default_route_table.private_route.id}"
  subnet_id      = "${aws_subnet.private_subnet.*.id[count.index]}"
  depends_on     = ["aws_default_route_table.private_route", "aws_subnet.private_subnet"]
}