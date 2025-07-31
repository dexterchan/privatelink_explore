resource "aws_lb" "privatelink_nlb" {
  name               = "privatelink-nlb"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.privatelink_nlb_sg.id]
  subnets            = [module.vpc-main.private_subnets[2]]
}

resource "aws_security_group" "privatelink_nlb_sg" {
  name        = "privatelink-nlb-sg"
  description = "Allow all traffic from anywhere"
  vpc_id      = module.vpc-main.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc-client.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_lb_target_group" "privatelink_tg" {
  name     = "privatelink-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = module.vpc-main.vpc_id

  health_check {
    protocol = "TCP"
    port     = "80"
  }
}

resource "aws_lb_target_group_attachment" "privatelink_tg_attachment" {
  target_group_arn = aws_lb_target_group.privatelink_tg.arn
  target_id        = aws_instance.main_ec2_instances[0].id
  port             = 80
}

resource "aws_lb_listener" "privatelink_listener" {
  load_balancer_arn = aws_lb.privatelink_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.privatelink_tg.arn
  }
}

resource "aws_vpc_endpoint_service" "privatelink_service" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.privatelink_nlb.arn]
}
resource "aws_vpc_endpoint" "privatelink_endpoint" {
  vpc_id            = module.vpc-client.vpc_id
  service_name      = aws_vpc_endpoint_service.privatelink_service.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids        = [module.vpc-client.private_subnets[0]]

  security_group_ids = [aws_security_group.client-privatelin-endpt-sg.id]

  private_dns_enabled = false
}
