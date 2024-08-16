variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-west-2"  # Change to your preferred region
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "The availability zone for the subnet."
  type        = string
  default     = "us-west-2a"  # Change to your preferred AZ
}

variable "allowed_cidr_block" {
  description = "The CIDR block allowed to access the RDS instance."
  type        = string
  default     = "0.0.0.0/0"  # Change to restrict access as needed
}

variable "allocated_storage" {
  description = "The allocated storage for the RDS instance."
  type        = number
  default     = 20
}

variable "engine_version" {
  description = "The PostgreSQL engine version."
  type        = string
  default     = "14.8"
}

variable "instance_class" {
  description = "The instance class for the RDS instance."
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
  default     = "mydatabase"  # Change to your database name
}

variable "db_username" {
  description = "The username for the database."
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The password for the database."
  type        = string
  default     = "mysecretpassword"  # Change to a secure password
  sensitive   = true
}

variable "publicly_accessible" {
  description = "Whether the RDS instance should be publicly accessible."
  type        = bool
  default     = true
}

variable "storage_autoscaling" {
  description = "Whether to enable storage autoscaling."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The number of days to retain backups."
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "The preferred backup window."
  type        = string
  default     = "07:00-09:00"
}

variable "maintenance_window" {
  description = "The preferred maintenance window."
  type        = string
  default     = "Mon:03:00-Mon:04:00"
}
