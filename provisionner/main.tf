provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "server1" {
  ami           = "ami-04681163a08179f28"
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.key_name
  
}
# generate keypair
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "aws_key_pair" "key" {
  key_name   = "wpkey"
  public_key = tls_private_key.tls.public_key_openssh
}
# save keypair in local file
resource "local_file" "key1" {
  filename        = "wpkey.pem"
  content         = tls_private_key.tls.private_key_pem
  file_permission = 400
}

# create security group
resource "null_resource" "name" {

  provisioner "local-exec" {  #to run a command on our local machine. In this case capturing the ip addresses and save them on a file.
    command = "echo ${aws_instance.server1.public_ip} > ip_address.txt"
    
  }
  
  provisioner "file" {                               #to copy a file to the target server
    source = "ip_address.txt"                      // path to the file to be copied
    destination = "/home/ec2-user/ip_address.txt" //destination for file to be copied
  }
  connection {
    type = "ssh"  // ssh -i wpkey.pem ec2-user@${aws_instance.server1.public_ip}
    user = "ec2-user"
    private_key = file("${local_file.key1.filename}")
    host = aws_instance.server1.public_ip

  }
  provisioner "remote-exec" {   #run some commands in our server after connecting through ssh
    inline = [
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo chmod -R 666 /var/www/html",
      "sudo echo '<h1>Welcome to Terraform</h1>' |sudo  tee  /var/www/html/index.html"
    ]
    
  }
  depends_on = [ aws_instance.server1, local_file.key1 ]
}