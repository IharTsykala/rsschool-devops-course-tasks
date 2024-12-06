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

echo "Installing Helm..."
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Adding Helm repositories for Prometheus and Grafana..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

echo "Deploying Prometheus..."
kubectl create namespace monitoring || echo "Namespace 'monitoring' already exists"
helm install prometheus prometheus-community/prometheus -n monitoring

echo "Deploying Grafana..."
helm install grafana grafana/grafana -n monitoring \
    --set adminPassword=admin \
    --set service.type=NodePort \
    --set service.nodePort=30001

echo "Waiting for Prometheus and Grafana pods to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=prometheus -n monitoring --timeout=300s
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=grafana -n monitoring --timeout=300s

echo "Retrieving Grafana admin password..."
GRAFANA_PASSWORD=$(kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode)
echo "Grafana admin password: $GRAFANA_PASSWORD"

echo "Prometheus and Grafana have been successfully deployed!"
echo "Grafana is accessible at http://<NODE_IP>:30001"
