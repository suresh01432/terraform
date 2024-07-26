# Resources Block
# Resource-1: Create VPC
resource "aws_vpc" "vpc-new" {
  cidr_block = "10.10.0.0/16"
  tags = {
    "Name" = "vpc-new"
  }
}

# Resource-2: create subnets
resource "aws_subnet" "vpc-new-public-subnet-1" {
 vpc_id = aws_vpc.vpc-new.id
 cidr_block = "10.10.1.0/24"
 availability_zone = "ap-south-1a"
 map_public_ip_on_launch = true
}

# Resource-3: Internet Gateway
resource "aws_internet_gateway" "vpc-new-igw" {
 vpc_id = aws_vpc.vpc-new.id
}
  
# Resource-4: Create Route Table
resource "aws_route_table" "vpc-new-public-route-table" {
  vpc_id = aws_vpc.vpc-new.id
}

# Resource-5:Create Route in route Table Internet Access
resource "aws_route" "vpc-new-public-route" {
  route_table_id = aws_route_table.vpc-new-public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.vpc-new-igw.id
}

# Resource-6: Associate the Route Table with the subnet
resource "aws_route_table_association" "vpc-new-public-route-table-association" {
  route_table_id = aws_route_table.vpc-new-public-route-table.id
  subnet_id = aws_subnet.vpc-new-public-subnet-1.id
}

# Resource-7: Create Security Group
resource "aws_security_group" "new-vpc-sg" {
  name        = "new-vpc-default-sg"
  description = "New VPC Default Security Group"
  vpc_id      = aws_vpc.vpc-new.id 

 ingress {
    description = "Allow Port 22"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
   description = "Allow port 80"
   from_port = 80
   to_port = 80
   protocol = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 egress {
   description = "Allow all Ip and ports Outbound"
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}