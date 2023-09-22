# main.tf

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_instance" "example" {
  ami           = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example.id
}
resource "aws_instance" "example2" {
  ami           = "ami-0261755bbcb8c4a84"
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.example.id
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
