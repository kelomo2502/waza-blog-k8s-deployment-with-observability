variable "project" {
  type        = string
  description = "Project name (e.g., waza-app)"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)"
}

variable "cluster_version" {
  type        = string
  default     = "1.29"
  description = "Kubernetes version for the cluster"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the EKS control plane"
}

variable "cluster_iam_role_arn" {
  type        = string
  description = "IAM role ARN for the EKS cluster"
}

variable "iam_dependency" {
  description = "Dependency link to IAM module so EKS waits for IAM setup"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}


variable "public_subnet_ids" {
  description = "Public subnets (usually for load balancers)"
  type        = list(string)
}

variable "node_group_name" {
  description = "Name of the EKS managed node group"
  type        = string
  default     = "waza-node-group"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of nodes in the group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of nodes in the group"
  type        = number
  default     = 2
}

variable "instance_types" {
  description = "EC2 instance types for worker nodes"
  type        = list(string)
  default     = ["t2.micro"]
}

variable "node_role_arn" {
  type        = string
  description = "IAM role ARN that nodes in the EKS node group will assume"
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair used for the EKS worker nodes"
  type        = string
  default = null
}