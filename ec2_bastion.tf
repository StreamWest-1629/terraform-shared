data "aws_ami" "amazon_linux_arm64" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }
}

resource "aws_key_pair" "bastion" {
  key_name   = "bastion"
  public_key = file("./.key/bastion.id_rsa.pub")
}

resource "aws_iam_role" "bastion" {
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  path = "/"
  tags = {
    ProjectName = var.PROJECT_NAME
  }
}

resource "aws_security_group" "bastion" {
  vpc_id = module.vpc_1.vpcid
  ingress {
    security_groups = [aws_security_group.main_alb.id]
    protocol        = "tcp"
    from_port       = 3443
    to_port         = 3443
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }
  tags = {
    Name        = "${var.PROJECT_NAME}-bastion"
    ProjectName = var.PROJECT_NAME
  }
}

resource "aws_instance" "bastion" {
  iam_instance_profile = aws_iam_role.bastion.id
  subnet_id            = module.vpc_1.public_subnet_id[0]
  ami                  = data.aws_ami.amazon_linux_arm64.id
  instance_type        = "t4g.nano"
  key_name             = aws_key_pair.bastion.key_name
  vpc_security_group_ids = [
    module.vpc_1.default_security_group_id,
    aws_security_group.bastion.id
  ]
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 8
    volume_type           = "gp2"
  }
  associate_public_ip_address = true
  tags = {
    Name        = "bastion"
    ProjectName = var.PROJECT_NAME
  }
}

output "bastion_fingerprint_public" {
  value = aws_key_pair.bastion.fingerprint
}
