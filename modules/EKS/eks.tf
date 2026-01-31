module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.15" # Latest 2026 release
}
