# security group

module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "movieapp-sg"
  description = "Security group for server"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
        from_port = 8080
        to_port = 8080
        protocol = "TCP"
        description = "Jenkins server"
        cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "TCP"
      description = "HTTPS"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      description = "SonarQube port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
        from_port = 0
        to_port = 0
        protocol = "-1"
        description = "All traffic"
        cidr_blocks = "0.0.0.0/0"
    }
  ]
}

#single instance to manage jenkins, sonarqube and trivy

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "movieapp-server"

  instance_type          = var.instance_type
  ami                    = var.ami
  key_name               = var.key_pair
  monitoring             = true
  vpc_security_group_ids = [module.sg.security_group_id]
  subnet_id              = var.subnet_id
  user_data              = file("user-data.sh")

  root_block_device = [
    { volume_size = 25
      volume_type = "gp3"
    }
  ]

  tags = {
    Environment = "dev"
    Name        = "movieapp-server"
  }

  
}

#attaching an elastic ip address for the instance
resource "aws_eip" "eip" {
  instance = module.ec2_instance.id
  domain   = "vpc"
}

#displaying the eip
output "eip" {
  value = aws_eip.eip.public_ip
}
