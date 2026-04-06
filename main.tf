resource "aws_vpc" "myVpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myVpc.id
  cidr_block              = var.subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch
}

resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.myVpc.id
  cidr_block              = var.subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = var.map_public_ip_on_launch
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myVpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rt2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg" {
  name   = "websg"
  vpc_id = aws_vpc.myVpc.id

  tags = {
    Name = "websg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "HTTP" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.allowed_ingress_cidr
  from_port         = var.http_port
  ip_protocol       = "tcp"
  to_port           = var.http_port
}

resource "aws_vpc_security_group_ingress_rule" "SSH" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.allowed_ingress_cidr
  from_port         = var.ssh_port
  ip_protocol       = "tcp"
  to_port           = var.ssh_port
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_instance" "instance_1" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.sub1.id
  user_data              = base64encode(file(var.userdata_file))
}

resource "aws_instance" "instance_2" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.sub2.id
  user_data              = base64encode(file(var.userdata_file))
}

resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]

  tags = {
    Name = "ALB"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = aws_vpc.myVpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.instance_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attachment2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.instance_2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.alb_listener_port
  protocol          = var.alb_listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

output "loadbalancerdns" {
  value = aws_lb.alb.dns_name
}