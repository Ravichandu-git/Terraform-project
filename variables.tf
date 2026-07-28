variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_name" {
  default = "mychandu-ec2"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}
