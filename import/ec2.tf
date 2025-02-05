
resource "aws_instance" "web" {
  ami                                  = "ami-0c614dee691cbbf37"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1f"
  instance_type                        = "t2.micro"
  key_name                             = "alb-key"
  monitoring                           = false
  security_groups                      = ["launch-wizard-5"]
  subnet_id                            = "subnet-0ec0ab528ffa4d6ea"
  tags = {
    Name = "Terraform -import"
  }
  vpc_security_group_ids      = ["sg-03a117f53823167fc"]

}
