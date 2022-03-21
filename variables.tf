variable "region" {
  description = "Region will be deployed"
  default     = "us-east-1"
}

variable "profile" {
  description = "Profile of the application"
  default = "tf069"
}

variable "name" {
  description = "Name of the application"
  default     = "ThiagoMachine"
}

variable "env" {
  description = "Environment of the application"
  default     = "dev"
}

variable "instance_type" {
  description = "AWS Instance type"
  default     = "t3.micro"
}

variable "repo" {
  description = "Repository of the application"
  default     = "github.com/mazzonixd"
}