variable "aws_region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

variable "cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "Exactly two subnet CIDR blocks (one per Availability Zone)."
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "availability_zones" {
  description = "Exactly two AZs to place the subnets into."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "map_public_ip_on_launch" {
  description = "Whether to auto-assign public IPv4 addresses to instances launched in the public subnets."
  type        = bool
  default     = true
}

variable "allowed_ingress_cidr" {
  description = "CIDR allowed to access the instances via HTTP/SSH."
  type        = string
  default     = "0.0.0.0/0"
}

variable "http_port" {
  description = "Port to allow inbound HTTP traffic."
  type        = number
  default     = 80
}

variable "ssh_port" {
  description = "Port to allow inbound SSH traffic."
  type        = number
  default     = 22
}

variable "s3_bucket_name" {
  description = "S3 bucket name. Must be globally unique, lowercase, and 3-63 chars."
  type        = string
  default     = "maleeshatfproject"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instances."
  type        = string
  default     = "ami-0ec10929233384c7f"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "userdata_file" {
  description = "Path to the user-data script file."
  type        = string
  default     = "userdata.sh"
}

variable "alb_name" {
  description = "Name of the Application Load Balancer."
  type        = string
  default     = "myalb"
}

variable "alb_listener_port" {
  description = "ALB listener port."
  type        = number
  default     = 80
}

variable "alb_listener_protocol" {
  description = "ALB listener protocol (HTTP or HTTPS)."
  type        = string
  default     = "HTTP"
}

variable "target_group_name" {
  description = "Name for the ALB target group."
  type        = string
  default     = "ALbTargetGroup"
}

variable "target_group_port" {
  description = "Port for the target group."
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for the target group."
  type        = string
  default     = "HTTP"
}