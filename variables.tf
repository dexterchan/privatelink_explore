variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-west-2"
}

variable "main_vpc_cidr_block" {
  description = "The CIDR block for the main VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "main_private_subnet_cidr_blocks" {
  description = "A list of CIDR blocks for the subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "main_public_subnet_cidr_blocks" {
  description = "A list of CIDR blocks for the subnets."
  type        = list(string)
  default     = ["10.0.128.0/24", "10.0.129.0/24", "10.0.130.0/24"]
}

variable "client_vpc_cidr_block" {
  description = "The CIDR block for the main VPC."
  type        = string
  default     = "172.16.0.0/16"
}

variable "client_private_subnet_cidr_blocks" {
  description = "A list of CIDR blocks for the subnets."
  type        = list(string)
  default     = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
}

variable "client_public_subnet_cidr_blocks" {
  description = "A list of CIDR blocks for the subnets."
  type        = list(string)
  default     = ["172.16.128.0/24", "172.16.129.0/24", "172.16.130.0/24"]
}

variable "availability_zones" {
  description = "availability zones to use for the VPC."
  type        = list(string)
  default     = ["us-west-2a"]
}