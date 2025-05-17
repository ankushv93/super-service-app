#
# Variables Configuration
#


variable "environment_name" {
  default = "non-production"	

}

variable "aws_region" {
  default  = "us-west-2"
}

variable "vpc_cidr" {
  type     = string
  default  = "10.0.0.0/16"

}

variable "no_of_public_subnet" {
  type     = number
  default  = 2	

}

variable "no_of_private_subnet" {
  type     = number
  default  = 2 
}

variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = string
}

variable "external_ip_addr_cidrs" {
 type    = list
 default = ["49.206.13.206/32","0.0.0.0/0"]

}

variable "namespace" {
  type    = string
  default = "app"

}
