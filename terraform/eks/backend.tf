terraform {
  backend "s3" {
    bucket = "2-tier-app-remote-backend"
    key    = "eks/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "remote-backend"
  }
}

