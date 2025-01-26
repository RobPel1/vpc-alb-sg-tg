terraform {
  backend "s3" {
    bucket = "w6-rp-bucket-terraform"
    key    = "w10/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt = true
  }
}