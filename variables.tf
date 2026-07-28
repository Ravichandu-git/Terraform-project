variable "aws_region" {
  default = "us-east-1"
}

variable "instance_name" {
  default = "demo-ec2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI"
}

variable "bucket_name" {
  description = "Globally unique bucket name"
}