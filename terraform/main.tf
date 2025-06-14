terraform {
  backend "s3" {
    bucket  = "terraform-states-ihar-tsykala"
    key     = "prod/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-central-1"
}
