# variables.tf
variable "region" {
  default = "us-east-1"
}

variable "vpcName" {
  default="Spider-VPC"
}

variable "vpSpiderIDRblock" {
    default ="spider"
}

variable "environmentName" {
  default ="spider"
}

variable "availabilityZonePublic" {
  default = "us-east-1b"
}

variable "availabilityZonePublic1" {
  default = "us-east-1c"
}


variable "availabilityZonePrivate1" {
  default = "us-east-1c"
}

variable "availabilityZonePrivate2" {
  default = "us-east-1c"
}

variable "availabilityZonePrivate3" {
  default = "us-east-1b"
}

variable "instanceTenancy" {
  default = "default"
}

variable "dnsSupport" {
  default = true
}
variable "dnsHostNames" {
  default = true
}
variable "vpcCIDRblock" {
  default = "10.22.0.0/16"
}
variable "public_subnet_cidr" {
  default = "10.22.1.0/24"
}

variable "public_subnet_cidr-1" {
  default = "10.22.4.0/24"
}


variable "private_subnet_cidr-1" {
  description = "CIDR for the private subnet"
  default     = "10.22.2.0/24"
}

variable "private_subnet_cidr-2" {
  description = "CIDR for the private subnet"
  default     = "10.22.3.0/24"
}

variable "private_subnet_cidr-3" {
  description = "CIDR for the private subnet"
  default     = "10.22.5.0/24"
}

variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
  #type    = "list"
  default = ["49.205.253.240/32"]
}
variable "mapPublicIP" {
  default = true
}


variable "servicename" {
    default="secretsmanager"
  
}

variable "endpointtype" {
    default="Interface"
  
}

variable "sg_id"{
  default="sg-07fd8bc7b070ca574"
}

variable "sg_id2"{
  default="sg-0bb37f5deaa680e7a"
}