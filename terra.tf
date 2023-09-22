# main.tf

resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-terra"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}
resource "aws_security_group" "ssh-access" {
  name   = "ssh-access"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
# create prublic subnet in az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Publicsubnet_az1"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "public_RT"
  }
}
resource "aws_route_table_association" "public_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_instance" "server1" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.web.key_name
  subnet_id              = aws_subnet.public_subnet_az1.id
  vpc_security_group_ids = [aws_security_group.ssh-access.id]
  #user_data              = file("ins_script.sh")
  #  count = 5
  tags = {
    Name = "public-ec2"
    #    Name = "Public-jump-${format("%02d", count.index + 1)}"
  }

}
resource "aws_key_pair" "web" {
  key_name   = "id_rsa"
  public_key = file("./id_rsa.pub")
}
resource "aws_s3_bucket" "tf-s3" {
  bucket = "s3-tfstate-6969"
  acl    = "private"
#  region = "us-east-1"
   force_destroy = true

  tags = {
    Name        = "tfstate-bucket"
    Environment = "Dev"
  }
}
