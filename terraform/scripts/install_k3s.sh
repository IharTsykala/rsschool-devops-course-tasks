#!/bin/bash
set -e

echo "Enabling SELinux and installing necessary dependencies..."
sudo amazon-linux-extras enable selinux-ng
sudo yum clean metadata
sudo yum install -y selinux-policy-targeted container-selinux

echo "Installing K3s..."
curl -sfL https://get.k3s.io | sh -

echo "Creating symbolic link for kubectl..."
sudo ln -s /usr/local/bin/k3s /usr/bin/kubectl

echo "K3s installation completed!"
kubectl version --client
