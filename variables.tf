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
  default = "repo:IharTsykala/rsschool-devops-course-tasks:ref:refs/heads/main"
}
