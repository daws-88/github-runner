terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.38.0"
    }
  }
  backend "s3" {
    bucket       = "remote-state-88-dev"
    key          = "github-runner"
    use_lockfile = true
    encrypt      = true
    region       = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
