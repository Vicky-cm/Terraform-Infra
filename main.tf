//VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "terraform-vpc"
    }
}

//Public subnet
resource "aws_subnet" "public" {
   vpc_id = aws_vpc.main.id
   cidr_block = "10.0.1.0/24"
   availability_zone = "us-east-1a"
   map_public_ip_on_launch = true

   tags = {
      Name = "terraform-public-subnet"
   }
}

//Internet Gateway
resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "terraform-igw"
    }
}

//Route table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
    }

    tags = {
        Name = "terraform-public-route-table"
    }
}

//Associate subnet with route table
resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

//Security group
resource "aws_security_group" "web" {
    name = "terraform-web-sg"
    vpc_id = aws_vpc.main.id

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
    Name = "terraform-web-sg"
   }
}
//EC2
resource "aws_instance" "web" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [
       aws_security_group.web.id
  ]

  user_data = <<-EOF
         #!/bin/bash
         dnf update -y
         dnf install -y nginx
         systemctl enable nginx
         systemctl start nginx
         echo "<h1> Hello from terraform!</h1>" > /usr/share/nginx/html/index.html
         EOF

   tags = {
    Name = "terraform-web-server"
   }
}


