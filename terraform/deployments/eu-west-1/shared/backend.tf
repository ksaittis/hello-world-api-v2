terraform {
  backend "s3" {
    bucket = "hello-world-api-v2-state-bucket"
    key    = "shared"
    region = "eu-west-1"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.58.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "dev"
}
