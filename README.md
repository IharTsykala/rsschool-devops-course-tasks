
# Kubernetes and Monitoring Deployment Project on AWS EC2

## Task: Deploy Kubernetes and Prometheus on AWS EC2 with Automation Script

In this project, we deploy a Kubernetes cluster on AWS EC2 using kubeadm, set up a monitoring solution with Prometheus, and expose Prometheus using a NodePort service. This guide walks you through the configuration, execution, and verification steps for successful deployment.

---

### Project File Structure

#### User-Data Script: `kubernetes_prometheus_deploy.sh`
This script automates the installation and configuration of Kubernetes, Docker, Helm, and Prometheus on an Amazon Linux 2 instance.

- **Purpose:** 
  - Initialize a Kubernetes cluster using `kubeadm`.
  - Install Docker, Helm, and Kubernetes tools.
  - Deploy Prometheus in a monitoring namespace.
  - Configure NodePort to expose Prometheus to external traffic.

---

### How to Run

#### Prerequisites
1. **AWS Account:** Ensure you have an AWS account and appropriate permissions to launch EC2 instances.
2. **Key Pair:** Create a key pair in AWS to connect to the EC2 instance if needed.
3. **Security Groups:** Ensure the required ports (e.g., 22, 31000) are open for SSH and Prometheus access.
4. **IAM Role:** Attach an IAM role with permissions for EC2 and networking tasks to your instance.

#### Steps to Execute

1. **Launch an EC2 Instance:**
   - Use Amazon Linux 2 AMI.
   - Add a script to `User data` during instance configuration:
     ```bash
     #!/bin/bash
     curl -o kubernetes_prometheus_deploy.sh https://example.com/path/to/kubernetes_prometheus_deploy.sh
     bash kubernetes_prometheus_deploy.sh
     ```
2. **Access Logs:**
   - Check `/var/log/user-data.log` for detailed script execution logs.

3. **Verify Kubernetes Deployment:**
   - Connect to the EC2 instance:
     ```bash
     ssh -i <key.pem> ec2-user@<public-ip>
     ```
   - Check the status of the Kubernetes cluster:
     ```bash
     kubectl get nodes
     ```

4. **Verify Prometheus Deployment:**
   - Retrieve the public IP of your EC2 instance and verify Prometheus:
     - URL: `http://<EC2_PUBLIC_IP>:31000`

---

### Script Breakdown

#### **`kubernetes_prometheus_deploy.sh`**

**Key Features:**
- **Docker Installation:**
  - Installs Docker and starts the Docker service.
  - Ensures Docker is enabled on boot.
  
- **Kubernetes Setup:**
  - Installs `kubeadm`, `kubectl`, and `kubelet`.
  - Initializes a single-node Kubernetes cluster with `kubeadm`.
  - Applies Weave Net as the CNI.

- **Helm Installation:**
  - Installs Helm (v3) for managing Kubernetes applications.

- **Prometheus Deployment:**
  - Creates a namespace for monitoring.
  - Deploys Prometheus using Helm from the Bitnami chart repository.
  - Exposes Prometheus via a NodePort service on port 31000.

- **Logging and Error Handling:**
  - Logs all actions and errors to `/var/log/user-data.log`.

**Dependencies Installed:**
- Docker
- Kubernetes tools (kubeadm, kubectl, kubelet)
- Helm (v3)

---

### Script Execution Flow

1. **Locale Setup:** Fixes locale-related issues on the EC2 instance.
2. **System Update:** Updates the system and installs required dependencies.
3. **Docker Installation:** Installs and configures Docker for Kubernetes.
4. **Kubernetes Tools Installation:** Installs kubeadm, kubectl, and kubelet.
5. **Cluster Initialization:** Sets up a Kubernetes cluster using `kubeadm`.
6. **CNI Configuration:** Installs Weave Net for pod networking.
7. **Helm Installation:** Installs Helm for Kubernetes application management.
8. **Prometheus Deployment:**
   - Creates a namespace (`monitoring`).
   - Deploys Prometheus using Helm.
   - Configures NodePort service for external access.
9. **Logging:** Logs detailed output for debugging and verification.

---

### How to Verify Deployment

1. **Check Cluster Nodes:**
   - Ensure the Kubernetes cluster is initialized:
     ```bash
     kubectl get nodes
     ```

2. **Verify Prometheus Deployment:**
   - Check that Prometheus pods are running:
     ```bash
     kubectl get pods -n monitoring
     ```
   - Verify that Prometheus is accessible:
     - Open `http://<EC2_PUBLIC_IP>:31000` in your browser.

3. **Troubleshooting:**
   - If the script fails, check logs:
     ```bash
     cat /var/log/user-data.log
     ```

---

### Cleanup

To clean up all resources:
1. Terminate the EC2 instance.
2. Remove any associated resources like security groups, key pairs, or IAM roles.

---

### Summary

This project automates the deployment of Kubernetes and Prometheus on AWS EC2. By leveraging the `kubeadm` and Helm tools, it ensures a streamlined setup process for monitoring workloads. The script provides robust logging for easy debugging and simplifies access to Prometheus with a NodePort service.

**Key Benefits:**
- Automates Kubernetes and Prometheus setup.
- Provides a lightweight monitoring solution.
- Simplifies access and configuration.

---

### Outputs Example

After the setup, you should see:
- **Kubernetes Cluster Status:**
  ```bash
  NAME    STATUS   ROLES    AGE   VERSION
  master  Ready    master   5m    v1.26.0
  ```
- **Prometheus URL:** `http://<EC2_PUBLIC_IP>:31000`
