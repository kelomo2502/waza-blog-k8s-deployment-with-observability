variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project identifier"
  type        = string
  default     = "waza-app"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)"
  default = "dev"
}

variable "cluster_name" {
  type        = string
  description = "Name of k8s cluster"
  default = "waza-app-cluster"
  
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}


variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ssh_key_name" {
  description = "The SSH key name used to access EC2 nodes in EKS"
  type        = string
  default     = "waza-eks-key"
}

