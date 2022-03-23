terraform {
  backend "s3" {
    bucket = "thiagomazzoni-state"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}