locals {
  https_separator = [
    {
      name     = "deeplab"
      hostname = "deeplab.kasai-san.dev"
      instance_port_pairs = [
        {
          port        = 3443
          instance_id = aws_instance.bastion.id
        }
      ]
    }
  ]
}

resource "aws_security_group" "main_alb" {
  vpc_id = module.vpc_1.vpcid
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }
  tags = {
    ProjectName = var.PROJECT_NAME
  }
}

resource "aws_lb" "main_alb" {
  name                       = "main"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [module.vpc_1.default_security_group_id, aws_security_group.main_alb.id]
  subnets                    = [module.vpc_1.public_subnet_id[0], module.vpc_1.public_subnet_id[1]]
  enable_deletion_protection = true
  tags = {
    ProjectName = var.PROJECT_NAME
  }
}

resource "aws_lb_listener" "main_alb_http" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = 503
    }
  }
}

resource "aws_lb_listener" "main_alb_https" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.primary.arn
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = 503
    }
  }
}

resource "aws_lb_listener_rule" "main_alb_https" {
  count        = length(local.https_separator)
  listener_arn = aws_lb_listener.main_alb_https.arn
  action {
    type             = "forward"
    target_group_arn = module.main_alb_https_target_group[count.index].arn
  }
  condition {
    host_header {
      values = [
        local.https_separator[count.index].hostname,
      ]
    }
  }
  priority = count.index + 1
}

module "main_alb_https_target_group" {
  count               = length(local.https_separator)
  source              = "./target_group/instance"
  vpcid               = module.vpc_1.vpcid
  name                = local.https_separator[count.index].name
  instance_port_pairs = local.https_separator[count.index].instance_port_pairs
  health_check_path   = "/"
  health_check_ok     = "200,302"
  tags = {
    ProjectName = var.PROJECT_NAME
  }
}
