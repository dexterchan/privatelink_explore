locals {
  s3_read_resources = [
    "arn:aws:s3:::${var.s3_read_bucket}",
    "arn:aws:s3:::${var.s3_read_bucket}/*"
  ]
}

resource "aws_instance" "main_ec2_instances" {
  count                  = 1
  ami                    = data.aws_ami.amzn_linux3.id
  instance_type          = "t4g.micro"
  subnet_id              = module.vpc-main.private_subnets[count.index]
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name
  vpc_security_group_ids = [aws_security_group.main-vpc-default-sg.id, aws_security_group.main-vpc-app-sg.id]
  user_data              = <<-EOF
              #!/bin/bash
              sudo amazon-linux-extras install -y nginx1
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF
  tags = {
    Name = "main-vm-${count.index + 1}"
  }
}


resource "aws_instance" "client_ec2_instances" {
  count                  = 1
  ami                    = data.aws_ami.amzn_linux3.id
  instance_type          = "t4g.micro"
  subnet_id              = module.vpc-client.private_subnets[count.index]
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name
  vpc_security_group_ids = [aws_security_group.client-vpc-default-sg.id, aws_security_group.client-vpc-app-sg.id]
  tags = {
    Name = "client-vm-${count.index + 1}"
  }
}


resource "aws_iam_role" "ssm_role" {
  name               = "ec2_ssm_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role_policy_attachment" "ecs_terraform_ec2_cloudwatch_role" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_attach_default" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}



resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ec2_ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_policy" "s3_read_access_policy" {
  count  = var.enable_s3_read_access ? 1 : 0
  name   = "ec2_ssm_s3_read_access"
  policy = data.aws_iam_policy_document.s3_read_access[0].json
}

data "aws_iam_policy_document" "s3_read_access" {
  count = var.enable_s3_read_access ? 1 : 0
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = local.s3_read_resources
  }
}

resource "aws_iam_role_policy_attachment" "ssm_s3_read_access" {
  count      = var.enable_s3_read_access ? 1 : 0
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.s3_read_access_policy[0].arn
}