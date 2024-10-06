// Common settings
variable "region" {
  default = "eu-central-1"
}

variable "bucket_name" {
  default = "terraform-states-ihar-tsykala"
}

variable "role_name" {
  default = "GithubActionsRole"
}

variable "oidc_provider" {
  default = "arn:aws:iam::851725512813:oidc-provider/token.actions.githubusercontent.com"
}

variable "repository" {
  default = "repo:ihartsykala/rsschool-devops-course-tasks:*"
}


//VPS Variables Definition

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet"
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for the first private subnet"
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  default     = "10.0.4.0/24"
}

variable "az_1" {
  description = "First availability zone"
  default     = "us-east-1a"
}

variable "az_2" {
  description = "Second availability zone"
  default     = "us-east-1b"
}
