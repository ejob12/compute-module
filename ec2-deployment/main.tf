# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "${var.name_prefix}-vpc" })
}

# Create Subnet
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Name = "${var.name_prefix}-subnet" })
}

# Create Security Group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "${var.name_prefix}-sg"

  # Allow SSH from within the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-sg" })
}

# Create EC2 Instance
resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = var.key_name
  tags                   = merge(var.tags, { Name = "${var.name_prefix}-ec2" })

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }
}

# Create EBS Volume
resource "aws_ebs_volume" "ebs" {
  availability_zone = var.availability_zone
  size              = var.ebs_volume_size
  type              = var.ebs_volume_type
  tags              = merge(var.tags, { Name = "${var.name_prefix}-ebs" })
}

# Attach EBS Volume to EC2 Instance
resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.ec2.id
}