terraform {
  # local backend

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.22.0"
    }
  }
}

provider "aws" {
  # can be defined via envvar, but I don't change it for my exercises
  region = "eu-west-1"
  default_tags {
    tags = {
      managed-by = "terraform"
    }
  }
}
