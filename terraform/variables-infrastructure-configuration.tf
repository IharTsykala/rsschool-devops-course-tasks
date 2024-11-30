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

variable "az_1" {
  description = "First availability zone"
  default     = "eu-central-1a"
}

variable "az_2" {
  description = "Second availability zone"
  default     = "eu-central-1b"
}

variable "k8s_master_ami" {
  default = "ami-0df0e7600ad0913a9"
}

variable "key_pair_name" {
  description = "Name of the AWS key pair for SSH access"
  default     = "key_pair_ihar-tsykala"
}
