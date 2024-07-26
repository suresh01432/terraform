# Resource-8: Create EC2 Instance
resource "aws_instance" "terraform-ec2-vm" {
 ami = "ami-068e0f1a600cd311c" # Amazon Linux
 instance_type = "t2.micro"
 key_name = "nexus"
 subnet_id = aws_subnet.vpc-new-public-subnet-1.id
 vpc_security_group_ids = [aws_security_group.new-vpc-sg.id]
 #user_data = file("apache-install.sh")
 user_data = <<-EOF
   #!/bin/bash
   sudo yum update -y
   sudo yum install httpd -y
   sudo systemctl enable httpd
   sudo systemctl start httpd
   echo "<h1>Welcome To AWS EC2 creation terraform </h1>" >/var/www/html/index.html
   EOF
   tags = {
    "Name" = "terraform-ec2-vm"
   }
}