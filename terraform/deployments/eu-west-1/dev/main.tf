terraform {
  backend "s3" {
    bucket         = "hello-world-api-v2-state-bucket"
    key            = "dev"
    region         = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
  profile = "dev"
}

module dev {
  source = "../../../modules"

  deployment_name = basename(abspath(path.module))
  # region = basename(abspath("${path.module}"))
}
