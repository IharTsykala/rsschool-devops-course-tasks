
# Terraform AWS Infrastructure Project

## Task 1: AWS Account Configuration

In this Terraform project, we configure an **S3 bucket** for Terraform state storage and create an IAM role named **GithubActionsRole** with the following policies:

- AmazonEC2FullAccess
- AmazonRoute53FullAccess
- AmazonS3FullAccess
- IAMFullAccess
- AmazonVPCFullAccess
- AmazonSQSFullAccess
- AmazonEventBridgeFullAccess

We also set up an **OpenID Connect provider for GitHub Actions** to authenticate and assume this role.

---

### Project File Structure (Task 1)

#### **main.tf**
Defines the backend configuration for the S3 bucket to store the Terraform state and sets up the AWS provider.

#### **iam.tf**
Creates the IAM role for GitHub Actions and attaches policies for access to AWS services.

#### **variables-aws-acc-configuration.tf**
Contains all variables for the project, such as the region, bucket name, role name, OIDC provider, and repository.

#### **.github/workflows/deploy.yml**
Defines the GitHub Actions workflow for deployment using Terraform.

---

## How to Run Task 1

1. **Install Terraform**  
   Install Terraform from the [official site](https://www.terraform.io/downloads.html) and verify installation:

   ```bash
   terraform -v
   ```

2. **Initialize Terraform**  
   Run the following command to initialize the project:

   ```bash
   terraform init
   ```

3. **Deploy the configuration**  
   Use the following commands to plan and apply the infrastructure:

   ```bash
   terraform plan
   terraform apply
   ```

4. **Verify the setup**  
   Ensure that the IAM role and S3 bucket are correctly configured for GitHub Actions.

---

# Task 2: Basic Infrastructure Configuration

In this task, we configure a **VPC** with **public and private subnets**, a **NAT instance**, a **Bastion host**, security groups, and route tables to ensure connectivity between the private and public resources. This configuration allows private instances to access the internet via the NAT instance while remaining isolated from public access.

---

### Project File Structure (Task 2)

#### **vpc.tf**
Defines the VPC, subnets, and main networking components.

#### **subnets_private.tf & subnets_public.tf**
Create public and private subnets within the VPC in separate availability zones.

#### **nat_instance.tf**
Creates the NAT instance with appropriate security groups and routing to allow internet access from private instances.

#### **bastion_instance.tf**
Creates the Bastion host in a public subnet to provide SSH access to private instances.

#### **security_group_private_to_bastion.tf**
Defines the security group to control traffic between the private instance and the Bastion host.

#### **security_group_private_to_nat.tf & security_group_public_from_nat.tf**
Configure the security groups to manage traffic between the NAT instance, private instances, and the internet.

#### **routes_public.tf**
Configures route tables for the public subnets, routing traffic through the **Internet Gateway (IGW)**.

#### **routes_private_nat.tf**
Creates a route table for private subnets, routing traffic through the **NAT instance** for internet access.

#### **nacl_associations_private.tf & nacl_associations_public.tf**
Associates network ACLs (NACLs) with private and public subnets to manage inbound and outbound traffic.

#### **network_acls_private.tf & network_acls_public.tf**
Define the private and public NACL rules to control access to and from the subnets.

#### **outputs.tf**
Provides important outputs such as VPC ID, public IPs, and instance IDs.

---

## How to Run Task 2

1. **Initialize Terraform**  
   Run the following command to initialize the project:

   ```bash
   terraform init
   ```

2. **Plan and Apply Configuration**  
   Use the following commands to plan and apply the infrastructure:

   ```bash
   terraform plan
   terraform apply
   ```

3. **Verify Setup**
    - Ensure the Bastion host is accessible via SSH.
    - Verify that private instances can reach the internet through the NAT instance.
    - Check that route tables, security groups, and NACLs are correctly associated.

---

## Cleanup

To destroy all resources, run the following command:

```bash
terraform destroy
```

---

## Outputs Example

The following outputs will be displayed after applying the configuration:

- **VPC ID**: `vpc-12345`
- **Public Subnet IDs**: `[subnet-abc, subnet-def]`
- **Bastion Public IP**: `203.0.113.25`
- **Bastion Instance ID**: `i-09876`
- **NAT Instance ID**: `i-01234`
- **Private Instance ID**: `i-56789`

---

## Summary

This Terraform project provides a comprehensive infrastructure configuration for AWS. The project ensures that private instances can securely access the internet via a NAT instance and can be managed through a Bastion host. The use of NACLs, security groups, and route tables ensures controlled access to the network and resources.
