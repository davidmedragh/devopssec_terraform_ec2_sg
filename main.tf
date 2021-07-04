resource "aws_security_group" "instance_sg" {
    name = "terraform-test-sg"

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

provider "aws" {
    region = "us-east-2"
    access_key = "AKIA32GFGEOFJSWBGIHT"
    secret_key = "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"
}

resource "aws_instance" "my_ec2_instance" {
    ami = "ami-07c1207a9d40bc3bd"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.instance_sg.id}"]

    user_data = <<-EOF
		#!/bin/bash
        sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		sudo echo "<h1>Hello devopssec</h1>" > /var/www/html/index.html
	EOF

    tags = {
        Name = "tarraform test"
    }
}