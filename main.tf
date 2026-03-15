module "vpc_module" {
  source = "./modules/vpc"
 
}

module "iam_user" {
  source = "./module/iam"
}

/*
module "eks" {
  source  = "./modules/EKS"
  }
*/  