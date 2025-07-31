

module "vpc-main" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = "main-vpc"
  cidr = var.main_vpc_cidr_block

  azs             = var.availability_zones
  public_subnets  = var.main_public_subnet_cidr_blocks
  private_subnets = var.main_private_subnet_cidr_blocks

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  tags = {
    Terraform = "true"
  }
}

resource "aws_security_group" "main-vpc-default-sg" {
  name        = "main-vpc-default-sg"
  description = "Allow all ingress from self and all egress"
  vpc_id      = module.vpc-main.vpc_id

  ingress {
    description = "Allow all traffic from self"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "main-vpc-default-sg"
    Terraform = "true"
  }
}


resource "aws_security_group" "main-vpc-app-sg" {
  name        = "main-vpc-app-sg"
  description = "Allow all HTTP ingress"
  vpc_id      = module.vpc-main.vpc_id

  ingress {
    description = "Allow all traffic from self"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = [module.vpc-main.vpc_cidr_block]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "main-vpc-default-sg"
    Terraform = "true"
  }
}