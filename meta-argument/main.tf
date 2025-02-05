/*
count = 2
depends_on =
for_each
lifecycke
*/



#count meta-argument when you want to create multiple resources
/*
resource "aws_instance" "s1" {
  count = 1
  ami = "ami-045269a1f5c90a6a0"
  instance_type = "t2.micro"

  tags = {
    Name = "dev-server${count.index}"
  }
}

#depends_on will wait for a specific resource to create before creating. 
#In this case, the user is waiting on the EC2 to be created before creating

resource "aws_iam_user" "us1" {
  name = "cloudadmin"
  depends_on = [ aws_instance.s1 ]
}



output "ip" {
    value = aws_instance.s1[*].public_ip
  
}


#for_each will create each resource with different characteristics. In this case
#we will create 2 instances with 2 different types "t2.micro" and "t3.small"
#if we have more strings in default, it will create more

variable "typeofinstances" {
    type = list(string)
  default = ["t2.micro", "t3.small"]
}

variable "info" {
    type = map(object({
        ami = string
        instance = string
    }))
    default = {  
    dev ={ami: "ami-045269a1f5c90a6a0", instance: "t2.micro"}
    qa = {ami: "ami-045269a1f5c90a6ahjghdfc", instance: "t2.micro"}
}
}
resource "aws_instance" "s2" {
  for_each = var.info 
  ami = each.value.ami
  instance_type = each.value.instance
  tags = {
    Name = each.key
  }
}

declaring variables

provider "aws" {
  region = var.region
}
variable "region" {
  description = "value of region"
  type = string
  sensitive = true
  //default = "us-east-1"
}
*/

#alias for provider block. we create an alias and when creating the resource we use the alias

/*
provider "aws" {
  region = "us-east-1"
  alias = "us1"
}
provider "aws" {
  region = "us-west-1"
  alias = "usw1"
}
resource "aws_instance" "server1" {
  provider = aws.us1
  ami = "ami-045269a1f5c90a6a0"
  instance_type = "t2.micro"
}



provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "name" {
  ami = "ami-0c614dee691cbbf37"
  instance_type = "t2.micro"
  lifecycle {
    //create_before_destroy = true
    prevent_destroy = false #to prevent accidental destroy
  }
}
*/