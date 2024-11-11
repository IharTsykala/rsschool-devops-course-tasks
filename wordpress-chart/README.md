
# Task 5: Simple Application Deployment with Helm

## Objective

In this task, we deployed a WordPress application on Kubernetes using Helm. The goal was to create a Helm chart for the application, deploy it to the Kubernetes cluster, and make it accessible via an external IP.

## Steps

### 1. **Create Helm Chart for WordPress**
   - We created a Helm chart for WordPress, which allowed us to deploy the application easily to the Kubernetes cluster. The chart was modified to meet the requirements of the Kubernetes setup.

### 2. **Deploy the WordPress Application Using Helm**
   - We deployed the WordPress application using the Helm chart. This involved configuring Kubernetes services and using Helm to deploy the application to the cluster.

### 3. **Verify the Application**
   - We verified the deployment of the WordPress application by checking its status and ensuring that it was accessible from the internet using the EXTERNAL-IP assigned to the WordPress service.

### 4. **Store Artifacts in Git**
   - The Helm chart and deployment configuration files were stored in a Git repository to manage version control and track the changes to the application and its Helm chart.

### 5. **Troubleshooting**
   - Issues related to the `LoadBalancer` service type and IP address assignment in Kubernetes were encountered, and the configuration was adjusted to ensure that the application was accessible externally.

## Files in the Project

### **metallb-config.yaml**
   - This file defines the configuration for MetalLB, the load balancer, including the IP address pool and advertisement configurations.

### **wp-service.yaml**
   - Defines the WordPress service, including its ports, labels, and load balancing configuration to expose it externally.

### **Helm Chart Files**
   - The `helm` chart was used to define the deployment and configurations for WordPress. This includes all necessary templates and values files.

## How to Run the Project

### 1. **Install Helm**

   First, ensure Helm is installed on your local machine:
   ```bash
   helm version
   ```

### 2. **Apply MetalLB Configuration**
   Apply the MetalLB configuration for IP address allocation:
   ```bash
   kubectl apply -f metallb-config.yaml
   ```

### 3. **Deploy WordPress Using Helm**
   - Deploy the WordPress service using the Helm chart:
   ```bash
   helm install wordpress-release ./wordpress --namespace my-namespace
   ```

### 4. **Verify the Application**
   - Check the status of the WordPress service to verify it has an external IP:
   ```bash
   kubectl get svc -n my-namespace
   ```

### 5. **Access the Application**
   - After the service is deployed and the external IP is assigned, access the WordPress application using the EXTERNAL-IP.

---

## Troubleshooting

### Issue: WordPress service not accessible
If the WordPress service does not get an EXTERNAL-IP, ensure MetalLB is properly configured and the IP range is correctly defined.

You can verify MetalLB configuration by running:
```bash
kubectl get pods -n metallb-system
```

If MetalLB pods are not running, check the logs and ensure that the configuration is correct.

### Issue: Helm installation failed
If the Helm install fails, check if there are any existing releases and delete them if necessary:
```bash
helm list -n my-namespace
helm uninstall wordpress-release -n my-namespace
```

---

## Cleanup

To destroy all resources, run the following command:

```bash
terraform destroy
```

---

## Summary

This task involved creating a Helm chart for WordPress, deploying the application using Kubernetes, and troubleshooting the IP allocation issues for MetalLB to ensure the application is accessible. By using Helm for deployment, we simplified the process and made it easy to manage updates and configuration changes.
