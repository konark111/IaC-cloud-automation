terraform {

  backend "s3" {
    bucket         = "s3-tfstate-6969"
    key            = "terraform.tfstate"
    
    region         = "us-east-1"
    # dynamodb_table = "dynamodb-tfstate-lock"
  }
}

