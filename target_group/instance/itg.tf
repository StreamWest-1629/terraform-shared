variable "name" {}
variable "vpcid" {}
variable "health_check_path" {}
variable "health_check_ok" {}
variable "instance_port_pairs" {}
variable "tags" {}

resource "aws_lb_target_group" "target_group" {
  name        = var.name
  vpc_id      = var.vpcid
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  health_check {
    enabled             = true
    path                = var.health_check_path
    matcher             = var.health_check_ok
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }
  slow_start = 0
  tags       = var.tags
}

resource "aws_lb_target_group_attachment" "pairs" {
  count            = length(var.instance_port_pairs)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.instance_port_pairs[count.index].instance_id
  port             = var.instance_port_pairs[count.index].port
}

output "arn" {
  value = aws_lb_target_group.target_group.arn
}
