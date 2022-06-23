provider "aws" {
    region = "ap-northeast-2"
}

module "web-cluster" {
  alias = "VPC"
  source = "../../global/module/web-cluster"
  terraform_vpc = var.terraform_vpc
  public_subnet_a = var.public_subnet_a
  public_subnet_c = var.public_subnet_c
  private_subnet_a_was = var.private_subnet_a_was
  private_subnet_c_was = var.private_subnet_c_was
  private_subnet_a_web = var.private_subnet_a_web
  private_subnet_c_web = var.private_subnet_c_web
}


variable "terraform_vpc" {
  description = "terraform vpc"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_a" {
  description = "public subnet a"
  type = string
  default = "10.100.1.0/24"
}

variable "public_subnet_c" {
  description = "public subnet c"
  type = string
  default = "10.100.2.0/24"
}

variable "az_a" {
  description = "az a"
  type = string
  default = "ap-northeast-2a"
}

variable "az_c" {
  description = "az c"
  type = string
  default = "ap-northeast-2c"
}

variable "private_subnet_a_web" {
  description = "private  web subnet a"
  type = string
  default = "10.100.3.0/24"  
}

variable "private_subnet_c_web" {
  description = "private  web subnet c"
  type = string
  default = "10.100.4.0/24"   
}

variable "private_subnet_a_was" {
  description = "private  was subnet a"
  type = string
  default = "10.100.5.0/24"  
}

variable "private_subnet_c_was" {
  description = "private  was subnet c"
  type = string
  default = "10.100.6.0/24"  
}