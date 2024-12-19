//vpc
resource "aws_vpc" "monitoring-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    name = "monitoring-vpc" 
  }
}

//subnet
resource "aws_subnet" "monitoring-subnet1" {
  vpc_id = aws_vpc.monitoring-vpc.id
  cidr_block = var.subnet1_cidr
  availability_zone = "us-east-1a"
  tags = {
    name = "monitoring-subnet1"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "monitoring-subnet2" {
  vpc_id = aws_vpc.monitoring-vpc.id
  cidr_block = var.subnet2_cidr
  availability_zone = "us-east-1b"
  tags = {
    name = "monitoring-subnet2"
  }
  map_public_ip_on_launch = true
}

//internet gateway to allow traffic from outside
resource "aws_internet_gateway" "monitoring-igw" {
  vpc_id = aws_vpc.monitoring-vpc.id
  tags = {
    name = "monitoring-igw"
  }
}

//route table to route the traffic to specific target group
resource "aws_route_table" "monitoring-rt" {
  vpc_id = aws_vpc.monitoring-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.monitoring-igw.id
  }

  tags = {
    name = "monitoring-rt"
  }
}

//associate subnets with the route table
resource "aws_route_table_association" "monitoring-rta1" {
  subnet_id = aws_subnet.monitoring-subnet1.id
  route_table_id = aws_route_table.monitoring-rt.id
}

resource "aws_route_table_association" "monitoring-rta2" {
  subnet_id = aws_subnet.monitoring-subnet2.id
  route_table_id = aws_route_table.monitoring-rt.id
}

//security group
resource "aws_security_group" "monitoring-sg" {
  vpc_id = aws_vpc.monitoring-vpc.id
  name = "monitoring-sg"
}

//inbound and outbound rules
resource "aws_vpc_security_group_ingress_rule" "monitoring-sg-inbound1" {
  security_group_id = aws_security_group.monitoring-sg.id
  description = "HTTP"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80 //http
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "monitoring-sg-inbound2" {
  security_group_id = aws_security_group.monitoring-sg.id
  description = "SSH"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22 //ssh
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "monitoring-sg-outbound" {
  security_group_id = aws_security_group.monitoring-sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = -1 //all ports
  to_port = -1
  ip_protocol = "-1" //all protocols
}

//ec2 instances
resource "aws_instance" "monitoring-ec2-1" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.monitoring-sg.id]
  subnet_id = aws_subnet.monitoring-subnet1.id
  user_data = base64encode(file("userdata.sh"))
  tags = {
    name = "monitoring-ec2-1"
  }
}

resource "aws_instance" "monitoring-ec2-2" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.monitoring-sg.id]
  subnet_id = aws_subnet.monitoring-subnet2.id
  tags = {
    name = "monitoring-ec2-2"
  }
}

//alb to route traffic from igw to instance
resource "aws_lb" "monitoring-alb" {
  name               = "monitoring-alb"
  internal           = false //making it public
  load_balancer_type = "application"
  security_groups    = [aws_security_group.monitoring-sg.id]
  subnets            = [aws_subnet.monitoring-subnet1.id, aws_subnet.monitoring-subnet2.id]
}

//create target group for the alb so that it knows where to route the traffic
resource "aws_lb_target_group" "monitoring-alb-tg" {
    name = "monitoring-alb-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.monitoring-vpc.id

    health_check { 
      path = "/"
      port = "traffic-port"
    }
}

//map the tg with the instances
resource "aws_lb_target_group_attachment" "monitoring-tg-attach1" {
  target_group_arn = aws_lb_target_group.monitoring-alb-tg.arn //tg doesnt have id name. instead it has resource name
  target_id = aws_instance.monitoring-ec2-1.id
}

resource "aws_lb_target_group_attachment" "monitoring-tg-attach2" {
  target_group_arn = aws_lb_target_group.monitoring-alb-tg.arn //tg doesnt have id name. instead it has resource name
  target_id = aws_instance.monitoring-ec2-2.id
}

//associate tg with the alb. else alb wont know the end target to route the traffic
resource "aws_alb_listener" "monitoring-alb-listener" {
  load_balancer_arn = aws_lb.monitoring-alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.monitoring-alb-tg.arn
    type = "forward"
  }
}
