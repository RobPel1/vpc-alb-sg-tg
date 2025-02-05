provider "aws" {
  region = "us-east-1"
}

import {
  to = aws_instance.web
  id = "i-08ae12ec511baf818" #instance id of instance created in AWS that we want to bring to Terraform to manage
}

