resource "aws_iam_role" "EC2_SSM_Role" {
  name = "EC2_SSM_Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "EC2_SSM_Policy" {
  role       = aws_iam_role.EC2_SSM_Role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.EC2_SSM_Role.name
}
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
resource "aws_instance" "web-server" {
  ami                  = data.aws_ami.latest_amazon_linux.id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.web-server_sg.name]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name


  user_data = <<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Welcome to Tech with Aden </h1>" > /var/www/html/index.html 
  EOF

  tags = {
    Name = "web_instance"
  }
}

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
