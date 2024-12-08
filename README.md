# Task 8: Grafana Installation and Dashboard Creation

## Objective

In this task, you will install Grafana on your Kubernetes (K8s) cluster using a Helm chart and create a dashboard to visualize Prometheus metrics.

---

### Steps to Execute

#### 1. Install Grafana
- Install Grafana on the Kubernetes cluster using the Helm chart provided by Bitnami:
  ```bash
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm repo update
  helm install grafana bitnami/grafana -n monitoring --create-namespace
  ```
- Verify that Grafana is installed and running:
  ```bash
  kubectl get pods -n monitoring
  ```

#### 2. Configure Grafana
- Retrieve the Grafana admin password:
  ```bash
  kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode
  ```
- Access Grafana using the default NodePort (or configure an Ingress for external access):
  - URL: `http://<NODE_IP>:<NODE_PORT>`
  - Login credentials:
    - Username: `admin`
    - Password: `<retrieved password>`
- Add a Prometheus data source:
  - Navigate to **Configuration > Data Sources > Add data source**.
  - Select **Prometheus** and provide the Prometheus URL (e.g., `http://prometheus.monitoring.svc.cluster.local:9090`).
  - Click **Save & Test**.

#### 3. Create a Dashboard
- Create a new dashboard in Grafana:
  - Navigate to **Create > Dashboard > Add new panel**.
  - Add panels for the following metrics:
    - CPU Utilization: `node_cpu_seconds_total`
    - Memory Usage: `node_memory_Active_bytes`
    - Storage Usage: `node_filesystem_avail_bytes`
  - Save the dashboard with an appropriate name.
- Export the dashboard to a JSON file:
  - Navigate to **Share > Export > Save to file**.

#### 4. Document the Setup
- Create a README file (this file) documenting the Grafana deployment and dashboard creation process.
- Include the JSON file of the dashboard layout.

---

### Outputs

#### Verify the Deployment
1. **Check Grafana Pod Status**:
   ```bash
   kubectl get pods -n monitoring
   ```

2. **Prometheus Data Source Configuration**:
   - Ensure the Prometheus data source is correctly configured in Grafana.

3. **Dashboard Verification**:
   - Verify that the created dashboard displays metrics such as CPU and memory utilization.

4. **JSON File of Dashboard Layout**:
   - Ensure the dashboard layout is exported as a JSON file.

---

### Cleanup

To remove Grafana from the cluster:
1. Uninstall the Helm release:
   ```bash
   helm uninstall grafana -n monitoring
   ```
2. Delete the monitoring namespace if no other resources exist:
   ```bash
   kubectl delete namespace monitoring
   ```

---

### Submission Checklist

1. Provide a PR with the automation script or CI/CD pipeline for Grafana deployment.
2. Attach the output of `kubectl get pods -n monitoring` with Grafana running.
3. Include screenshots of:
   - Prometheus data source configuration.
   - Created dashboard.
4. Provide the exported JSON file of the dashboard layout.
5. Include a README file (this file) documenting the Grafana deployment and dashboard setup.

---

### References

- [Grafana Documentation](https://grafana.com/docs/)
- [Helm Chart for Grafana](https://github.com/bitnami/charts/tree/main/bitnami/grafana)
- [Understanding Machine CPU Usage](https://www.robustperception.io/understanding-machine-cpu-usage/)

---

### Example Outputs

1. **Pods in Monitoring Namespace**:
   ```bash
   NAME                         READY   STATUS    RESTARTS   AGE
   grafana-xxxxxxxxxx-xxxxx     1/1     Running   0          10m
   ```

2. **Dashboard Export JSON File**:
   - Example JSON content is saved in a separate file.
3. **Access Grafana**:
   - URL: `http://<NODE_IP>:<NODE_PORT>`
   - Username: `admin`
   - Password: `<retrieved password>`
