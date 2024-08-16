provider "aws" {
  region = var.aws_region
}

# Create the EC2 instance
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  # Use the existing security group from the default VPC
  vpc_security_group_ids = [var.security_group_id]

  key_name = var.key_name

  # Configure storage
  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp2"
  }

  tags = {
    Name = var.instance_name
  }
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}
