
# Task 1: AWS Account Configuration

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

## Project file structure

### **main.tf**
Defines the backend configuration for the S3 bucket to store the Terraform state and sets up the AWS provider.

### **iam.tf**
Creates the IAM role for GitHub Actions and attaches policies for access to AWS services.

### **variables-aws-acc-configuration.tf**
Contains all variables for the project, such as the region, bucket name, role name, OIDC provider, and repository.

### **.github/workflows/deploy.yml**
Defines the GitHub Actions workflow for deployment using Terraform. It contains steps for formatting, planning, and applying the Terraform configuration automatically upon code changes in the `main` branch.

### **.gitignore**
Lists the files to be ignored by Git in this project.

### **README.md**
This documentation file.

---

## How to run

### 1. Install Terraform
Install Terraform from the [official site](https://www.terraform.io/downloads.html) and verify installation:

```bash
terraform -v
```

---

# Task 2: Basic Infrastructure Configuration

In this task, we configure a **Virtual Private Cloud (VPC)** along with **public and private subnets**, a **NAT instance**, security groups, and route tables. This infrastructure ensures that **instances in private subnets can access the internet** while remaining **inaccessible from the public internet**.

---

## Project file structure

### **main.tf**
Sets up the AWS provider and backend configuration, referencing the various Terraform modules.

### **vpc.tf**
Creates the **VPC** with DNS support to host networking resources.

```hcl
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}
```

### **subnets.tf**
Defines **two public** and **two private subnets** across different availability zones for redundancy and high availability.

### **nat_instance.tf**
Creates a **NAT Instance** in the public subnet to allow instances in private subnets to access the internet.

```hcl
resource "aws_instance" "nat_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  EOF

  tags = {
    Name = "nat-instance"
  }
}
```

### **private_routes.tf**
Configures **route tables** for the private subnets, ensuring outbound traffic goes through the NAT instance.

```hcl
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = aws_instance.nat_instance.id
  }

  tags = {
    Name = "private-route-table"
  }
}
```

### **nacl_associations.tf**
Associates **NACL** with public subnets and binds **route tables** with private subnets.

```hcl
resource "aws_subnet_network_acl_association" "public_nacl_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  network_acl_id = aws_network_acl.public_nacl.id
}

resource "aws_route_table_association" "private_rt_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}
```

### **logging.tf**
Enables **VPC Flow Logs** to monitor and capture network traffic within the VPC.

### **security_groups.tf**
Defines **security groups** to control inbound and outbound traffic, ensuring access is restricted to only necessary ports.

### **outputs.tf**
Outputs key values such as **VPC ID**, **NAT Instance ID**, and **Route Table IDs**.

### **variables-infrastructure-configuration.tf**
Contains reusable variables like subnet CIDRs, availability zones, and VPC CIDR for easy management.

---

## How to run

### 1. Install Terraform
Install Terraform from the [official site](https://www.terraform.io/downloads.html) and verify installation:

```bash
terraform -v
```

### 2. Initialize the project
Initialize the Terraform configuration by running:

```bash
terraform init
```

### 3. Format the code
Ensure the Terraform code is formatted correctly:

```bash
terraform fmt
```

### 4. Validate the configuration
Check the validity of the Terraform code:

```bash
terraform validate
```

### 5. Plan the deployment
Preview the changes that will be applied:

```bash
terraform plan
```

### 6. Apply the configuration
Deploy the resources:

```bash
terraform apply
```

### 7. Verify the setup
- Ensure the **NAT instance** is running in the public subnet.
- Verify that instances in private subnets can access the internet through the NAT instance.
- Check that **VPC Flow Logs** are capturing traffic.

---

## How to destroy the infrastructure

To tear down all resources, use:

```bash
terraform destroy
```
