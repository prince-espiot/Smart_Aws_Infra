# Setup VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name ="${var.vpc_name}-main"
  }
}


# Setup public subnet
resource "aws_subnet" "public_subnets" {
  count             = length(var.cidr_public_subnet)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_public_subnet[count.index]
  availability_zone = var.eu_availability_zone[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index + 1}"
    "kubernetes.io/role/elb"                               = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
  # Explicitly define dependencies to ensure subnets are created after the VPC
  depends_on = [aws_vpc.main]
}

# Setup private subnet
resource "aws_subnet" "private_subnets" {
  count             = length(var.cidr_private_subnet)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_private_subnet[count.index]
  availability_zone = var.eu_availability_zone[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb"                     = "1" # Correct tag for private subnets
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}


# Setup Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.environment}-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "${var.environment}-public-rt"
  }
}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "public_rt_subnet_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

# Private Route Table #Note: This is a route table for private subnet
resource "aws_route_table" "private_subnets" {
  vpc_id = aws_vpc.main.id
  #depends_on = [aws_nat_gateway.nat_gateway]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "${var.environment}-private-rt"
  }
}

# Private Route Table and private Subnet Association
resource "aws_route_table_association" "private_rt_subnet_association" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_subnets.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_gateway_eip" {
  count  = length(var.eu_availability_zone) # Create one EIP per AZ
  domain = "vpc"

  tags = {
    Name = "${var.environment}-nat-gateway-eip-${count.index + 1}"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  count       = length(var.eu_availability_zone) # One NAT Gateway per AZ
  allocation_id = aws_eip.nat_gateway_eip[count.index].id
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)

  tags = {
    Name = "${var.environment}-nat-gateway-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

/*# Private Route Table and private Subnet Association
resource "aws_route" "private_route" {
  count          = length(var.cidr_private_subnet)
  route_table_id = aws_route_table.private_subnets.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = element(aws_nat_gateway.nat_gateway[*].id, count.index)
}*/
