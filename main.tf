provider "aws" {
  region = "us-east-1"
}

module "ec2_deployment" {
  source = "./ec2-deployment"

  name_prefix       = "liontech-demo"
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidr       = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  ami_id            = "ami-04b4f1a9cf54c11d0" # Replace with your AMI ID
  instance_type     = "t2.micro"
  key_name          = "rancher"
  root_volume_size  = 20
  ebs_volume_size   = 10
  tags = {
    Environment = "test"
    Terraform   = "true"
  }
}

output "ec2_public_ip" {
  value = module.ec2_deployment.ec2_public_ip
}