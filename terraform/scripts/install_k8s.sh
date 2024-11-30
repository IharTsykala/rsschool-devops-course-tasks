#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
exec > >(tee /var/log/user-data.log | logger -t user-data) 2>&1

# Function for logging steps
log_step() {
    echo "=== $1 ==="
}

log_step "Starting script execution"

# Fixing locale issues
log_step "Setting up locale"
sudo localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || true
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Update the system and install dependencies
log_step "Updating system and installing required dependencies"
sudo yum update -y
sudo yum install -y curl wget tar jq

# Install Docker
log_step "Installing Docker"
if ! command -v docker &> /dev/null; then
    sudo yum install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker
else
    log_step "Docker is already installed"
fi

# Install Kubernetes tools (kubectl, kubeadm, kubelet)
log_step "Installing Kubernetes tools"
if ! command -v kubectl &> /dev/null; then
    log_step "Enabling Kubernetes in amazon-linux-extras"
    sudo yum install -y amazon-linux-extras
    if sudo amazon-linux-extras enable kubernetes; then
        sudo yum install -y kubelet kubeadm kubectl
        sudo systemctl enable kubelet
    else
        log_step "Kubernetes is not available in amazon-linux-extras, trying manual installation"
        cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
        sudo yum install -y kubelet kubeadm kubectl
        sudo systemctl enable kubelet
    fi
else
    log_step "Kubernetes tools are already installed"
fi

# Disable swap (required for Kubernetes)
log_step "Disabling swap"
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Initialize Kubernetes cluster
log_step "Initializing Kubernetes cluster"
if [ ! -f /etc/kubernetes/admin.conf ]; then
    sudo kubeadm init --pod-network-cidr=192.168.0.0/16
else
    log_step "Kubernetes cluster is already initialized"
fi

# Configure kubectl for the current user
log_step "Configuring kubectl for current user"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Weave Net as the CNI
log_step "Installing Weave Net CNI"
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version --client --short | awk '{print $3}')"

# Allow workloads on the master node
log_step "Allowing workloads on the master node"
kubectl taint nodes --all node-role.kubernetes.io/master- || log_step "Workloads already allowed on master node"

# Install Helm
log_step "Installing Helm"
if ! command -v helm &> /dev/null; then
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
    log_step "Helm is already installed"
fi

# Create namespace for monitoring
log_step "Creating namespace for monitoring"
kubectl create namespace monitoring || log_step "Namespace 'monitoring' already exists"

# Install Prometheus using Helm
log_step "Installing Prometheus"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install prometheus bitnami/prometheus --namespace monitoring || log_step "Prometheus is already installed"

# Set up NodePort for Prometheus
log_step "Setting up NodePort for Prometheus"
cat <<EOF | sudo tee /tmp/prometheus-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: prometheus-server
  namespace: monitoring
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 9090
      protocol: TCP
      nodePort: 31000
  selector:
    app.kubernetes.io/name: prometheus
    app.kubernetes.io/component: server
EOF
kubectl apply -f /tmp/prometheus-service.yaml

# Retrieve external IP address and print the Prometheus URL
log_step "Retrieving external IP address"
NODE_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
if [ -z "$NODE_IP" ]; then
    log_step "Failed to retrieve external IP address"
else
    log_step "Prometheus is accessible at: http://${NODE_IP}:31000"
fi

log_step "Setup completed successfully"
