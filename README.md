
# Jenkins Pipeline and Kubernetes Deployment Project

## **Overview**

This project automates the deployment of an application to a Kubernetes (K8s) cluster using Jenkins and Helm, with Docker images stored in AWS Elastic Container Registry (ECR). The infrastructure is provisioned using Terraform, and the pipeline ensures code quality with SonarQube analysis and unit tests.

---

## **Pipeline Objectives**

1. **Automate Infrastructure Deployment**  
   - Use Terraform to provision AWS resources, including a Kubernetes cluster and a Jenkins server.
   - Store Terraform state in a secure backend.

2. **Docker Image Management**  
   - Build Docker images for the application.
   - Push Docker images to AWS Elastic Container Registry (ECR).

3. **Kubernetes Deployment**  
   - Use Helm to deploy the application to a Kubernetes cluster.
   - Verify the deployment by checking pod readiness and service availability.

4. **Pipeline Configuration**  
   - Store the Jenkins pipeline as a `Jenkinsfile` in the main repository.
   - Trigger the pipeline on each Git push.

5. **Code Quality and Testing**  
   - Execute unit tests during the pipeline.
   - Perform a security check using SonarQube.

6. **Notifications and Documentation**  
   - Notify via email about the pipeline status (success or failure).
   - Document the pipeline and deployment process.

---

## **File Structure**

### **Project Root**

- **`.github/workflows/deploy.yml`**  
  - GitHub Actions workflow for initializing Terraform and triggering Jenkins.

- **`Jenkinsfile`**  
  - Defines the Jenkins pipeline with steps for building, testing, and deploying the application.

---

### **Infrastructure (`terraform/`)**

#### **Files**
- **`main.tf`**  
  Configures AWS resources and the backend for Terraform state.

- **`jenkins_instance.tf`**  
  Provisions an EC2 instance with Jenkins pre-installed and configured.

- **`k3s_instance.tf`**  
  Deploys a K3s Kubernetes cluster on an EC2 instance.

- **`outputs.tf`**  
  Outputs necessary information such as the Jenkins public IP.

- **`security_group_*.tf`**  
  Configures security groups for Kubernetes, Jenkins, and other resources.

---

### **Application (`app/`)**

#### **Files**
- **`Dockerfile`**  
  Defines the Docker image for the application.

- **`package.json`**  
  Contains dependencies and scripts for running and testing the application.

- **`src/`**  
  Source code of the application.

---

### **Helm Chart (`helm-chart/`)**

#### **Files**
- **`Chart.yaml`**  
  Metadata for the Helm chart.

- **`values.yaml`**  
  Configurable values such as Docker image repository and service ports.

- **`templates/`**  
  Templates for Kubernetes manifests, including Deployment and Service.

---

## **Pipeline Steps**

### **1. Application Build**
- **Purpose:** Build the application and ensure all dependencies are installed.
- **Command:**  
  ```bash
  npm install
  ```

### **2. Unit Test Execution**
- **Purpose:** Run unit tests to ensure application correctness.
- **Command:**  
  ```bash
  npm test
  ```

### **3. Security Check with SonarQube**
- **Purpose:** Analyze the codebase for vulnerabilities and ensure code quality.
- **Command:**  
  ```bash
  sonar-scanner -Dsonar.projectKey=my-app -Dsonar.sources=./src
  ```

### **4. Docker Image Building and Pushing to ECR**
- **Purpose:** Build a Docker image for the application and push it to AWS ECR.
- **Command:**  
  ```bash
  docker build -t <repository-uri>:<tag> .
  docker push <repository-uri>:<tag>
  ```

### **5. Deployment to K8s Cluster with Helm**
- **Purpose:** Deploy the application using Helm to the Kubernetes cluster.
- **Command:**  
  ```bash
  helm upgrade --install my-app helm-chart --set image.repository=<repository-uri> --set image.tag=<tag>
  ```

### **6. Application Verification**
- **Purpose:** Verify that the application is running and accessible.
- **Command:**  
  ```bash
  kubectl wait --for=condition=ready pod -l app=my-app --timeout=120s
  curl http://<service-ip>:3000
  ```

### **7. Notifications**
- **Purpose:** Send email notifications for pipeline success or failure.

---

## **How to Run**

### **1. Clone the Repository**
```bash
git clone https://github.com/rsschool-devops-course-tasks.git
cd rsschool-devops-course-tasks
```

### **2. Deploy Infrastructure**
```bash
cd terraform
terraform init
terraform apply -auto-approve
```

### **3. Trigger Jenkins Pipeline**
- The Jenkins pipeline is automatically triggered on each push to the repository.

### **4. Verify Deployment**
- Ensure that the application is running:
  ```bash
  kubectl get pods
  kubectl get svc my-app
  ```

---

## **Notifications**

Email notifications are sent to `ihartsykala24@gmail.com` upon pipeline completion.

---

## **Documentation**

1. **Helm Chart Validation**
   - Run the following command to validate the Helm chart locally:
     ```bash
     helm template my-app ./helm-chart
     ```

2. **SonarQube Setup**
   - Configure SonarQube in Jenkins and use the `sonar-scanner` CLI for analysis.

3. **ECR Access**
   - Ensure Kubernetes nodes can access the ECR repository by assigning the appropriate IAM role to instances.

---

## **Outputs**

After deployment, the following information is available:
- **Jenkins Public IP:** Access the Jenkins UI at `http://<jenkins-public-ip>:8080`.
- **Kubernetes Service IP:** The application is available at `http://<service-ip>:3000`.

---

## **Cleanup**

To remove all resources, run:
```bash
terraform destroy
```

---

## **Summary**

This project demonstrates a fully automated CI/CD pipeline for deploying an application to Kubernetes using Jenkins, Terraform, Docker, and Helm. With email notifications and thorough application verification, this setup ensures reliability and transparency in the deployment process.
