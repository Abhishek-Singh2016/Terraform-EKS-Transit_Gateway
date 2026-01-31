module "vpc_module" {
  source = "./modules/vpc"
 
}

module "eks" {
  source  = "./modules/EKS"
  }