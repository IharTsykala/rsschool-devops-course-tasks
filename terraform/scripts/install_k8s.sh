#!/bin/bash

set -e
set -u
set -o pipefail

echo "=== Starting script execution ==="

# Setting up locale
echo "=== Setting up locale ==="
yum install -y glibc-locale-source glibc-langpack-en || true
localedef -i en_US -f UTF-8 en_US.UTF-8 || echo "Warning: Failed to generate locale en_US.UTF-8"
export LANG=en_US.UTF-8

# Killing existing YUM processes
echo "=== Killing existing YUM processes ==="
if pgrep -x "yum" > /dev/null; then
    pkill -9 yum
    rm -f /var/run/yum.pid
fi

# Resolving unfinished yum transactions
echo "=== Resolving unfinished yum transactions ==="
yum-complete-transaction --cleanup-only || true

# Cleaning up duplicate packages and system
echo "=== Cleaning up duplicates and system ==="
yum install -y yum-utils || true
package-cleanup --cleandupes -y || true
yum clean all
yum update --skip-broken -y

# Install Docker if not installed
if ! command -v docker &> /dev/null; then
    echo "=== Installing Docker ==="
    amazon-linux-extras enable docker
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -aG docker "$USER"
fi

# Install Kubernetes CLI tools (kubectl)
KUBECTL_VERSION="v1.31.3"
if ! command -v kubectl &> /dev/null; then
    echo "=== Installing kubectl ==="
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/kubectl
fi

# Verify kubectl installation
echo "=== Verifying kubectl installation ==="
if ! kubectl version --client &> /dev/null; then
    echo "kubectl installation failed. Check PATH or permissions."
    exit 1
fi

# Disable swap
echo "=== Disabling swap ==="
swapoff -a
sed -i '/swap/d' /etc/fstab

# Start Docker if not running
echo "=== Ensuring Docker is running ==="
if ! systemctl is-active --quiet docker; then
    systemctl start docker
    systemctl enable docker
fi

# Check Kubernetes cluster connection
echo "=== Checking Kubernetes cluster ==="
if ! kubectl cluster-info &> /dev/null; then
    echo "Kubernetes cluster not reachable. Ensure kubeconfig is correctly configured."
    exit 1
fi

# Install Helm
HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | jq -r '.tag_name')
if ! command -v helm &> /dev/null; then
    echo "=== Installing Helm ==="
    curl -LO "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz"
    tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz
    mv linux-amd64/helm /usr/local/bin/helm
    rm -rf helm-${HELM_VERSION}-linux-amd64.tar.gz linux-amd64
fi

# Verify Helm installation
echo "=== Verifying Helm installation ==="
if ! helm version &> /dev/null; then
    echo "Helm installation failed. Check PATH or permissions."
    exit 1
fi

# Install Prometheus via Helm
echo "=== Installing Prometheus via Helm ==="
kubectl create namespace monitoring || true
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring

echo "=== Script execution completed successfully ==="
