variable "global_vpc" {
  description = "global vpc"
  type = string
  default = "10.100.0.0/16"
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

variable "private_subnet_a_DB" {
  description = "private db subnet a"
  type = string
  default = "10.100.7.0/24" 
}

variable "private_subnet_c_DB" {
  description = "private db subnet c"
  type = string
  default = "10.100.8.0/24" 
}

variable "ec2_ami" {
  description = "ec2_ami"
  default = "ami-0cbec04a61be382d9" #amazon linux 2 AMI
  type = string
}

variable "launch_web" {
  description = "lauch web"
  type = string
  default = "ami-0cbec04a61be382d9" #amazon linux 2 AMI
}

variable "launch_was" {
  description = "lauch was"
  type = string
  default = "ami-0cbec04a61be382d9" #amazon linux 2 AMI
}

variable "min_size" {
  description = "The minimum number of EC2 Instance in the ASG"
  type        = number
  default = 2
}

variable "max_size" {
  description = "The maximum number of EC2 Instance in the ASG"
  type        = number
  default = 3
}