locals {
  common_tags = {
    project         = "${lower(var.projectName)}"
    environment      = "${lower(var.environmentName)}"
    AutoTag_Creator       = "${var.createdBy}"
    AutoTag_CreateTime       = "${var.createdOn}"
    business-unit  = "${var.businessUnit}"
    operation-owner = "${var.operationOwner}"
    customer-name    ="${var.customer-name}"
    product-version ="${var.productVersion}"
    product         = "${lower(var.projectName)}"
    decommission-date ="${var.decommissionDate}"
    team-access = "${var.teamaccess}"
  }
}

#default-tags
#
projectName="EKS-Multi-Region-Setup"
createdOn="29-01-2026"
businessUnit="information-technology"
operationOwner="Automation"
createdBy="terraform"
product="EKS"
teamaccess="Automation-Team"