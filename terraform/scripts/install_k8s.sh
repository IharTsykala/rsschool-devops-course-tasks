#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Configure the Kubernetes repository
echo "Configuring Kubernetes repository..."
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Update the system with the Kubernetes repository temporarily disabled
echo "Disabling Kubernetes repository temporarily to allow system update..."
sudo yum update --disablerepo=kubernetes -y

# Clean up yum cache
echo "Cleaning up yum cache..."
sudo yum clean all

# Validate the Kubernetes repository configuration
echo "Testing the Kubernetes repository configuration..."
sudo yum repolist

# Perform any additional deployment steps here
# Example: Installing Docker
echo "Installing Docker..."
sudo amazon-linux-extras enable docker
sudo yum install -y docker
sudo service docker start
sudo usermod -aG docker ec2-user

# Installing Kubernetes tools if needed
echo "Installing kubectl..."
sudo yum install -y kubectl

# Final system update to ensure everything is up-to-date
echo "Running final system update..."
sudo yum update -y

# Additional setup (Optional)
echo "Deployment script completed successfully!"
