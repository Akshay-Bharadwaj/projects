resource "aws_vpc" "akshay-vpc" {
  cidr_block = var.vpc-cidr
  tags = {
    name = "akshay-vpc"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.akshay-vpc.id
  cidr_block = var.subnet1-cidr
  availability_zone = "us-east-1a"
  tags = {
    name = "subnet-1"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.akshay-vpc.id
  cidr_block = var.subnet2-cidr
  availability_zone = "us-east-1b"
  tags = {
    name = "subnet-2"
  }
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "akshay-igw" {
  vpc_id = aws_vpc.akshay-vpc.id
  tags = {
    name = "akshay-igw"
  }
}

resource "aws_route_table" "akshay-route-table" {
  vpc_id = aws_vpc.akshay-vpc.id

  route {
    //establising traffic through route table from anywhere to the vpc via the igw
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.akshay-igw.id
  }

  tags = {
    name = "akshay-route-table"
  }
}

//associate or connect the subnets with the route table
resource "aws_route_table_association" "akshay-rta1" {
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.akshay-route-table.id
}

resource "aws_route_table_association" "akshay-rta2" {
  subnet_id = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.akshay-route-table.id
}

//security group for the instances inside subnets to allow specific traffic
resource "aws_security_group" "akshay-security-group" {
  vpc_id = aws_vpc.akshay-vpc.id
  name = "akshay-security-group"
}

//configure inbound and outbound rules
resource "aws_vpc_security_group_ingress_rule" "ingress-rule1" {
  security_group_id = aws_security_group.akshay-security-group.id
  description = "HTTP from VPC"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80 //http
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress-rule2" {
  security_group_id = aws_security_group.akshay-security-group.id
  description = "SSH from VPC"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22 //ssh
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress-rule" {
  security_group_id = aws_security_group.akshay-security-group.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = -1 //all ports
  to_port = -1
  ip_protocol = "-1" //all protocols
}

//create s3 bucket
resource "aws_s3_bucket" "akshay-s3-bucket" {
  bucket = "akshay-s3-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

//making s3 bucket as public
resource "aws_s3_bucket_public_access_block" "akshay-s3-bucket" {
  bucket = aws_s3_bucket.akshay-s3-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

//create ec2 instances in each subnet with the security group for inbound/outbound rules
resource "aws_instance" "akshay-server1" {
  ami = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.akshay-security-group.id]
  subnet_id = aws_subnet.subnet-1.id
  user_data = base64encode(file("userdata1.sh")) //run the necessary commands in a secured way from the file to build the application
  tags = {
    name = "akshay-server1"
  }
}

resource "aws_instance" "akshay-server2" {
  ami = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.akshay-security-group.id]
  subnet_id = aws_subnet.subnet-2.id
  user_data = base64encode(file("userdata2.sh")) //run the necessary commands in a secured way from the file to build the application
  tags = {
    name = "akshay-server2"
  }
}

//create application load balancer to manage the traffic and route them to instances
resource "aws_lb" "akshay-alb" {
  name               = "akshay-alb"
  internal           = false //making it public
  load_balancer_type = "application"
  security_groups    = [aws_security_group.akshay-security-group.id]
  subnets            = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
}

//create target group for the alb so that it knows where to route the traffic
resource "aws_lb_target_group" "akshay-alb-tg" {
    name = "akshay-alb-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.akshay-vpc.id

    health_check {   //tg checks the health of target. if instances are down, it wont route the traffic
      path = "/"
      port = "traffic-port"
    }
}

//map the tg with the instances
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.akshay-alb-tg.arn //tg doesnt have id name. instead it has resource name
  target_id = aws_instance.akshay-server1.id
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.akshay-alb-tg.arn //tg doesnt have id name. instead it has resource name
  target_id = aws_instance.akshay-server2.id
  port = 80
}

//associate tg with the alb. else alb wont know the end target to route the traffic
resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.akshay-alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.akshay-alb-tg.arn
    type = "forward"
  }
}

//getting the output in terminal
output "loadbalancerdns" {
  value = aws_lb.akshay-alb.dns_name //display the DNS of alb in terminal
}