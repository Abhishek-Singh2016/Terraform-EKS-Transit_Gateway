terraform {
  backend "s3" {
    bucket         = "abhishek-ops-tf-state-backend"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    
  }
}