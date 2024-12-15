
# Task 9: Grafana Alerting Configuration and Verification

## Objective

In this task, we configure Grafana Alerting to send email notifications for specific events in a Kubernetes (K8s) cluster and verify that alerts are received.

---

## Steps to Execute

### 1. Configure SMTP for Grafana

1. Update the Grafana configuration to enable SMTP email notifications:
   - Modify the SMTP settings in the `values.yaml` file for Grafana (if using Helm) or directly configure the SMTP settings in the `grafana.ini` file for local setups.
   - Example SMTP configuration for a local setup:
     ```ini
     [smtp]
     enabled = true
     host = "smtp.example.com:587"
     user = "your-email@example.com"
     password = "your-password"
     from_address = "your-email@example.com"
     from_name = "Grafana Alerts"
     skip_verify = true
     ```

2. Apply the updated configuration:
   ```bash
   helm upgrade grafana bitnami/grafana -n monitoring -f values.yaml
   ```

3. Verify the SMTP configuration:
   - Navigate to **Alerting > Notification Channels** in Grafana.
   - Send a test email to ensure SMTP is configured correctly.

---

### 2. Configure Contact Points

1. Add a new contact point in Grafana for email notifications:
   - Navigate to **Alerting > Contact Points**.
   - Click **New Contact Point** and configure it as follows:
     - **Name**: `email-contact`
     - **Type**: Email
     - **Addresses**: `ldapexample23@gmail.com`
     - **Subject**: `[{{ .CommonLabels.alertname }}] Alert from Grafana`
   - Save the contact point.

2. Test the contact point:
   - Send a test notification to confirm it is working.

---

### 3. Configure Alert Rules

1. Create alert rules for the following conditions:
   - **High CPU Utilization**:
     - Query:
       ```promql
       (sum(rate(node_cpu_seconds_total[5m])) by (instance)) / count(node_cpu_seconds_total{mode="idle"}) by (instance) > 0.9
       ```
   - **Low RAM Capacity**:
     - Query:
       ```promql
       (sum(node_memory_MemAvailable_bytes{job="node-exporter"})) / sum(node_memory_MemTotal_bytes{job="node-exporter"}) < 0.1
       ```

2. Steps to create an alert rule:
   - Navigate to **Alerting > Alert Rules** in Grafana.
   - Click **New Alert Rule**.
   - Configure the alert query, threshold, and evaluation time.
   - Link the rule to the contact point created earlier.

3. Save the rules with appropriate names:
   - `HighCPUUtilization`
   - `LowRAM`

---

### 4. Verify Alerts

1. Simulate high CPU utilization:
   - Use the `stress` tool to create CPU load on a Kubernetes node:
     ```bash
     sudo apt install stress
     stress --cpu 2 --timeout 300
     ```

2. Simulate low RAM capacity:
   - Use `stress` or similar tools to allocate memory:
     ```bash
     stress --vm 2 --vm-bytes 128M --timeout 300
     ```

3. Verify alert behavior:
   - Ensure alerts are triggered and received in your email.

---

## Outputs

### Verify Configuration and Alerts

1. **SMTP Configuration**:
   - Test emails sent from Grafana are received.

2. **Alert Rules**:
   - Alerts for high CPU utilization and low RAM are firing when conditions are met.

3. **Email Notifications**:
   - Emails are received with the expected alert details.

### JSON Export of Alert Rules

1. Export the alert rules configuration:
   - Navigate to **Alerting > Export Rules** in Grafana.
   - Save the configuration as a JSON file.

---

## Cleanup

1. Remove created alert rules and contact points in Grafana if no longer needed.
2. Uninstall the Grafana Helm release:
   ```bash
   helm uninstall grafana -n monitoring
   ```

---

## Submission Checklist

1. Provide a PR with configuration files or automation scripts for:
   - Grafana SMTP configuration.
   - Alert Rules (exported JSON).
   - Contact Points (exported JSON).
2. Include screenshots of:
   - Contact Points configuration.
   - Alert Rules in normal and firing states.
   - Received alert emails.
3. Include this README documenting the setup process.

---

### References

- [Grafana Documentation](https://grafana.com/docs/)
- [Grafana Alerting](https://grafana.com/docs/grafana/latest/alerting/)
- [stress Command Documentation](https://linux.die.net/man/1/stress)

---

### Example Outputs

1. **Alert Email Example**:
   ```
   Subject: [HighCPUUtilization] Alert from Grafana

   Instance: node-exporter-prometheus-node-exporter.monitoring.svc.cluster.local:9100
   Status: Firing
   ```

2. **Pods in Monitoring Namespace**:
   ```bash
   NAME                         READY   STATUS    RESTARTS   AGE
   grafana-xxxxxxxxxx-xxxxx     1/1     Running   0          10m
   ```
