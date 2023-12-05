resource "aws_security_group" "web-server_sg" {
  name        = var.security_group_name
  description = var.security_group_description

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.security_group_ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.security_group_egress_cidr_blocks
  }
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_instance" "web-server" {
  ami                  = data.aws_ami.latest_amazon_linux.id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.web-server_sg.name]
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

  user_data = <<-EOF
    #!/bin/bash 
    sudo su
    yum update -y
    yum install -y https://s3.us-east-2.amazonaws.com/amazon-ssm-us-east-2/latest/linux_amd64/amazon-ssm-agent.rpm
    yum install httpd -y
    systemctl start httpd
    systemctl enable httpd
    echo "<html><h1> Welcome to Tech with Asli Aden ! </h1></html>" >> /var/www/html/index.html       
  EOF

  tags = {
    Name = "web_instance"
  }
}
