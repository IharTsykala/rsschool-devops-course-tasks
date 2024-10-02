# Task 1: AWS Account Configuration

In this Terraform project, we configure an S3 bucket for Terraform state storage and create an IAM role named **GithubActionsRole** with the following policies:

- AmazonEC2FullAccess
- AmazonRoute53FullAccess
- AmazonS3FullAccess
- IAMFullAccess
- AmazonVPCFullAccess
- AmazonSQSFullAccess
- AmazonEventBridgeFullAccess

We also set up an OpenID Connect provider for GitHub Actions to authenticate and assume this role.

## Project file structure

### main.tf
Defines the backend configuration for the S3 bucket to store the Terraform state, and sets up the AWS provider.

### iam.tf
Creates the IAM role for GitHub Actions and attaches policies for access to AWS services.

### variables.tf
Contains all variables for the project, such as the region, bucket name, role name, OIDC provider, and repository.

### .github/workflows/deploy.yml
Defines GitHub Actions workflow for deployment using Terraform. It contains steps for formatting, planning, and applying the Terraform configuration automatically upon code changes in the `main` branch.

### .gitignore
Lists the files to be ignored by Git in this project.

### README.md
This documentation file.

## How to run

### 1. Install Terraform
Install Terraform from the [official site](https://www.terraform.io/downloads.html) and verify installation:

```bash
terraform -v
