variable "region" {
  description = "AWS Region"
  type        = string
  default     = "me-central-1" # Middle East (Bahrain) for data residency
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "sadad-resilient-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}
