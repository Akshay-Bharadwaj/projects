variable "cidr_block" {
  description = "vpc cidr block"
}

variable "cidr_blocks" {
  description = "sg cidr blocks"
}

variable "ami" {
  description = "instance ami"
  default     = "ami-0453ec754f44f9a4a"
}

variable "instance_type" {
  description = "instance type"
  default     = "t2.micro"
}

