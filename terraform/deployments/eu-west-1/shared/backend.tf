terraform {
  backend "s3" {
    bucket         = "hello-world-api-state-bucket"
    key            = "shared"
    region         = "eu-west-1"
  }
}
