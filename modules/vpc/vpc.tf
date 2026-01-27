# vpc.tf 
# Create VPC/Subnet/Security Group/ACL

# create the VPC
resource "aws_vpc" "createVPC" {
  cidr_block           = "${var.vpSpiderIDRblock}"
  instance_tenancy     = "${var.instanceTenancy}"
  enable_dns_support   = "${var.dnsSupport}"
  enable_dns_hostnames = "${var.dnsHostNames}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.vpcName}",
      "product", "${var.vpcName}"
    )
  )}"
}

# end resource

# create the Subnet
resource "aws_subnet" "createPublicSubnet" {
  vpc_id                  = "${aws_vpc.createVPC.id}"
  cidr_block              = "${var.public_subnet_cidr}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.availabilityZonePublic}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.vpcName}_Public",
      "product", "${var.vpcName}_Public"
    )
  )}" 
}
# end resource
# create the Subnet
resource "aws_subnet" "createPublicSubnet1" {
  vpc_id                  = "${aws_vpc.createVPC.id}"
  cidr_block              = "${var.public_subnet_cidr-1}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.availabilityZonePublic1}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.vpcName}_Public1",
      "product", "${var.vpcName}_Public1"
    )
  )}"
}

# Define the private subnet
resource "aws_subnet" "createPrivateSubnet1" {
  vpc_id            = "${aws_vpc.createVPC.id}"
  cidr_block        = "${var.private_subnet_cidr-1}"
  availability_zone = "${var.availabilityZonePrivate1}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.vpcName}_Private1",
      "product", "${var.vpcName}_Private1"
    )
  )}" 
}

output "ACE_Project_Private_Subnet" {
  value = "${aws_subnet.createPrivateSubnet1.id}"
}

# Define the private subnet

resource "aws_subnet" "createPrivateSubnet2" {
  vpc_id            = "${aws_vpc.createVPC.id}"
  cidr_block        = "${var.private_subnet_cidr-2}"
  availability_zone = "${var.availabilityZonePrivate2}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.vpcName}_Private2",
      "product", "${var.vpcName}_Private2"
    )
  )}"
}
# Define the private subnet
resource "aws_subnet" "createPrivateSubnet3" {
  vpc_id            = "${aws_vpc.createVPC.id}"
  cidr_block        = "${var.private_subnet_cidr-3}"
  availability_zone = "${var.availabilityZonePrivate3}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.vpcName}_Private3",
      "product", "${var.vpcName}_Private3"
    )
  )}"
}


# Create the Security Group
resource "aws_security_group" "createSecurityGroup" {
  vpc_id      = "${aws_vpc.createVPC.id}"
  name        = "Spider_JUMP_Server_SG"
  description = "Security group for Jump server"
  ingress {
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["${aws_vpc.createVPC.cidr_block}"]
}

egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["8.39.54.0/23","204.141.42.0/23","65.154.166.0/24","136.143.190.0/23","216.52.72.0/23","204.141.32.0/23","8.40.222.0/23","31.186.243.0/24","185.20.209.150/32","185.20.209.0/24","185.20.211.0/24","87.252.213.0/24","89.36.170.0/24","89.36.171.0/24","163.53.93.0/24","163.53.94.0/27","43.228.181.48/29","103.89.75.0/24","103.89.74.0/24","103.103.196.0/22","103.117.158.0/23","34.206.108.39/32"]
}


  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Spider_JUMP_Server_SG",
      "product", "Spider_JUMP_Server_SG"
    )
  )}"
}
# end resource

# create VPC Network aSpideress control list
resource "aws_network_acl" "createNetworkACL" {
  vpc_id     = "${aws_vpc.createVPC.id}"
  subnet_ids = ["${aws_subnet.createPublicSubnet.id}"]
    ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port  = 0
    to_port    = 0
  }
    tags = "${merge(
    local.common_tags,
    map(
      "Name", "Spider_VPC_ACL_Public",
      "product", "Spider_VPC_ACL_Public"
    )
  )}"
}
# end resource

resource "aws_network_acl" "createNetworkACL1" {
  vpc_id     = "${aws_vpc.createVPC.id}"
  subnet_ids = ["${aws_subnet.createPublicSubnet1.id}"]
    ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port  = 0
    to_port    = 0
  }
    tags = "${merge(
    local.common_tags,
    map(
      "Name", "Spider_VPC_ACL_Public1",
      "product", "Spider_VPC_ACL_Public1"
    )
  )}"
}

resource "aws_route_table" "createPublicRouteTable1" {
  vpc_id = "${aws_vpc.createVPC.id}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "SpiderPublicRouteTable1",
      "product", "SpiderPublicRouteTable1"
    )
  )}"
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
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Spider_Internet_GateWay",
      "product", "Spider_Internet_GateWay"
    )
  )}"
}
# end resource

# Create the Route Table
resource "aws_route_table" "createPublicRouteTable" {
  vpc_id = "${aws_vpc.createVPC.id}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "SpiderPublicRouteTable",
       "product", "SpiderPublicRouteTable",
    )
  )}"
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
  vpc      = true
  depends_on = ["aws_internet_gateway.createInternetGateway"]
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Spider_Elastic_NAT",
       "product", "Spider_Elastic_NAT",
    )
  )}"
}

resource "aws_nat_gateway" "associateNATGateway" {
    allocation_id = "${aws_eip.createNATGateway.id}"
    subnet_id = "${aws_subnet.createPublicSubnet.id}"
    depends_on = ["aws_internet_gateway.createInternetGateway"]
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Spider_NAT_Gateway",
      "product", "Spider_NAT_Gateway",

    )
  )}"
}

resource "aws_route_table" "createPrivateRouteTable" {
    vpc_id = "${aws_vpc.createVPC.id}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Spider_Private_Route_Table",
      "product", "Spider_Private_Route_Table",
    )
  )}"
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


/*resource "aws_route" "associatePrivate_Route" {
	route_table_id  = "${aws_route_table.createPrivateRouteTable.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.associateNATGateway.id}"
}*/




/*resource "aws_route_table_association" "ACE_Project_Priavte_Subnet_Association" {
    subnet_id = "${aws_subnet.ACE_Project_Private.id}"
    route_table_id = "${aws_route_table.ACE_Project_Private_Route.id}"
          tags={
        Name = "ACE_Project_Priavte_Subnet_Association"
    }
}*/
# end vpc.tf
