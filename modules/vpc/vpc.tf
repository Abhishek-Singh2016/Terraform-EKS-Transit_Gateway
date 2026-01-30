# vpc.tf 
# Create VPC/Subnet/Security Group/ACL

# create the VPC
resource "aws_vpc" "createVPC" {
  cidr_block           = "${var.vpcCIDRblock}"
  instance_tenancy     = "${var.instanceTenancy}"
  enable_dns_support   = "${var.dnsSupport}"
  enable_dns_hostnames = "${var.dnsHostNames}"
  tags = local.common_tags
}

# end resource

# create the Subnet
resource "aws_subnet" "createPublicSubnet" {
  vpc_id                  = "${aws_vpc.createVPC.id}"
  cidr_block              = "${var.public_subnet_cidr}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.availabilityZonePublic}"
  tags = local.public_eks_tags 
}
# end resource
# create the Subnet
resource "aws_subnet" "createPublicSubnet1" {
  vpc_id                  = "${aws_vpc.createVPC.id}"
  cidr_block              = "${var.public_subnet_cidr-1}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.availabilityZonePublic1}"
  tags = local.common_tags
}

# Define the private subnet
resource "aws_subnet" "createPrivateSubnet1" {
  vpc_id            = "${aws_vpc.createVPC.id}"
  cidr_block        = "${var.private_subnet_cidr-1}"
  availability_zone = "${var.availabilityZonePrivate1}"
  tags = local.private_eks_tags 
}

output "ACE_Project_Private_Subnet" {
  value = "${aws_subnet.createPrivateSubnet1.id}"
}

# Define the private subnet

resource "aws_subnet" "createPrivateSubnet2" {
  vpc_id            = "${aws_vpc.createVPC.id}"
  cidr_block        = "${var.private_subnet_cidr-2}"
  availability_zone = "${var.availabilityZonePrivate2}"
  tags = local.private_eks_tags
}
# Define the private subnet
resource "aws_subnet" "createPrivateSubnet3" {
  vpc_id            = "${aws_vpc.createVPC.id}"
  cidr_block        = "${var.private_subnet_cidr-3}"
  availability_zone = "${var.availabilityZonePrivate3}"
  tags = local.common_tags
}


resource "aws_route_table" "createPublicRouteTable1" {
  vpc_id = "${aws_vpc.createVPC.id}"
  tags = local.common_tags
}
# end resource

# Create the Internet ASpideress
resource "aws_route" "createInternet_ASpideress1" {
  route_table_id         = "${aws_route_table.createPublicRouteTable1.id}"
  destination_cidr_block = "${var.destinationCIDRblock}"
  gateway_id             = "${aws_internet_gateway.createInternetGateway.id}"
}
# end resource

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "associateRouteTable1" {
  subnet_id      = "${aws_subnet.createPublicSubnet1.id}"
  route_table_id = "${aws_route_table.createPublicRouteTable1.id}"

}
# end resource

# Create the Internet Gateway
resource "aws_internet_gateway" "createInternetGateway" {
  vpc_id = "${aws_vpc.createVPC.id}"
  tags = local.common_tags
}
# end resource

# Create the Route Table
resource "aws_route_table" "createPublicRouteTable" {
  vpc_id = "${aws_vpc.createVPC.id}"
  tags = local.common_tags
}
# end resource

# Create the Internet ASpideress
resource "aws_route" "createInternet_ASpideress" {
  route_table_id         = "${aws_route_table.createPublicRouteTable.id}"
  destination_cidr_block = "${var.destinationCIDRblock}"
  gateway_id             = "${aws_internet_gateway.createInternetGateway.id}"
}
# end resource

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "associateRouteTable" {
  subnet_id      = "${aws_subnet.createPublicSubnet.id}"
  route_table_id = "${aws_route_table.createPublicRouteTable.id}"
  
}

#For NAT Gateway-29/07/2019
#create this IP to assign it the NAT Gateway 
resource "aws_eip" "createNATGateway" {
  domain     = "vpc"
  depends_on = ["aws_internet_gateway.createInternetGateway"]
  tags = local.common_tags
}

resource "aws_nat_gateway" "associateNATGateway" {
    allocation_id = "${aws_eip.createNATGateway.id}"
    subnet_id = "${aws_subnet.createPublicSubnet.id}"
    depends_on = ["aws_internet_gateway.createInternetGateway"]
  tags = local.common_tags
}

resource "aws_route_table" "createPrivateRouteTable" {
    vpc_id = "${aws_vpc.createVPC.id}"
  tags = local.common_tags
}

resource "aws_route" "associatePrivate_Route" {
	route_table_id  = "${aws_route_table.createPrivateRouteTable.id}"
	destination_cidr_block = "${var.destinationCIDRblock}"
	nat_gateway_id = "${aws_nat_gateway.associateNATGateway.id}"
}

resource "aws_route_table_association" "associatePriavteSubnet1" {
    subnet_id = "${aws_subnet.createPrivateSubnet1.id}"
    route_table_id = "${aws_route_table.createPrivateRouteTable.id}"
}

resource "aws_route_table_association" "associatePriavteSubnet2" {
    subnet_id = "${aws_subnet.createPrivateSubnet2.id}"
    route_table_id = "${aws_route_table.createPrivateRouteTable.id}"
}

resource "aws_route_table_association" "associatePriavteSubnet3" {
    subnet_id = "${aws_subnet.createPrivateSubnet3.id}"
    route_table_id = "${aws_route_table.createPrivateRouteTable.id}"
}

# end vpc.tf
