variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "admin_cidr" {
  description = "Your admin IP in CIDR format (e.g., 203.0.113.4/32)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ami" {
  description = "AMI ID for instances (Ubuntu)"
  type        = string
  # Update with a valid Ubuntu AMI for your region
  default     = "ami-0c2b8ca1dad447f8a"
}

variable "key_name" {
  description = "Existing AWS EC2 keypair name to use"
  type        = string
  default     = ""
}

variable "bastion_instance_type" {
  description = "Instance type for bastion"
  type        = string
  default     = "t3.micro"
}

variable "private_instance_type" {
  description = "Instance type for private server"
  type        = string
  default     = "t3.micro"
}
