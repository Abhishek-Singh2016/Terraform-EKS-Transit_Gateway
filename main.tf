module "vpc_module" {
  source = "./modules/vpc"
 
}

module "iam_user" {
  source = "./modules/iam"
}

/*
module "eks" {
  source  = "./modules/EKS"
  }
*/  