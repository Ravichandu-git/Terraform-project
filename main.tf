module "ec2" {
  source = "./modules/ec2"

  instance_name = "demo-ec2"
  ami_id         = "ami-09d88f7c4c272b0c5" # Amazon Linux 2023 (example)
  instance_type  = "t3.micro"
}

module "s3" {
  source = "./modules/s3"

  bucket_name = "my-az-demo-bucket-ravi220"
}
