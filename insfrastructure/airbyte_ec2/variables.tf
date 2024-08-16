variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-west-2"  # Change to your preferred region
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance."
  type        = string
  default     = "ami-08c39d32a4aa1d3a4"  # Amazon Linux 2023 AMI (64-bit(x86))
}

variable "instance_type" {
  description = "The instance type for the EC2 instance."
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "The name of the SSH key pair to use for the EC2 instance."
  type        = string
  default     = "my-key"  # Replace with your key pair name after creation
}

variable "subnet_id" {
  description = "The subnet ID within the default VPC."
  type        = string
}

variable "security_group_id" {
  description = "The ID of the existing security group in the default VPC."
  type        = string
}

variable "volume_size" {
  description = "The size of the root EBS volume in GB."
  type        = number
  default     = 10
}

variable "instance_name" {
  description = "The name tag for the EC2 instance."
  type        = string
  default     = "MyEC2Instance"  # Change as needed
}
