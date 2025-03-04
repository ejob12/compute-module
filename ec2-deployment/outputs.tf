output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.subnet.id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.sg.id
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ec2.id
}

output "ebs_volume_id" {
  description = "The ID of the EBS volume"
  value       = aws_ebs_volume.ebs.id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.ec2.public_ip
}