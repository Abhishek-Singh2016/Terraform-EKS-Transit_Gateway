module "vpc_module" {
  source = "./modules/vpc"
 
}

module "eks_module" {
  source = "./modules/EKS"
 
}