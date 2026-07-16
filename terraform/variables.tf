variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "my_ip" {
  description = "Your public IP address for security group access"
  type        = string
  default     = "172.216.250.30"
}