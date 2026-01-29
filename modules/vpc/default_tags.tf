locals {
  common_tags = {
    project         = "${lower(var.projectName)}"
    environment      = "${lower(var.environmentName)}"
  }
}

variable "projectName" {
  default="Multi-Region-EKS"
  
}
