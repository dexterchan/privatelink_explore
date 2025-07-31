

module "vpc-client" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = "client-vpc"
  cidr = var.client_vpc_cidr_block

  azs             = var.availability_zones
  public_subnets  = var.client_public_subnet_cidr_blocks
  private_subnets = var.client_private_subnet_cidr_blocks

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  tags = {
    Terraform = "true"
  }
}

resource "aws_security_group" "client-vpc-default-sg" {
  name        = "client-vpc-default-sg"
  description = "Allow all ingress from self and all egress"
  vpc_id      = module.vpc-client.vpc_id

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
    Name      = "client-vpc-default-sg"
    Terraform = "true"
  }
}
resource "aws_security_group" "client-privatelin-endpt-sg" {
  name        = "client-privatelink-endpt"
  description = "Allow HTTP ingress from client-vpc-default-sg"
  vpc_id      = module.vpc-client.vpc_id

  ingress {
    description     = "Allow HTTP from client-vpc-default-sg"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.client-vpc-default-sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "client-vpc-http-sg"
    Terraform = "true"
  }
}
