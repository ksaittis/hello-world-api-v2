variable project_name {
  type        = string
  default     = "hello-world"
  description = "Project name, used across multiple resources"
}

variable deployment_name {
  type = string
  description = "Deployment name, has to be unique"
}

variable vpc_cidr {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC cidr range"
}

variable region {
  type = string
  default = "eu-west-1"
  description  = "VPC region name"
}