# Project Setup

This project demonstrates an automated CI/CD pipeline with Jenkins, Docker, Terraform, and Kubernetes.

## Steps

1. Build and push Docker image to ECR.
2. Deploy application to Kubernetes using Helm.
3. Notifications sent to email for pipeline status.

## Jenkins Pipeline

- Stages:
  1. Build application.
  2. Run tests.
  3. Perform security checks.
  4. Build and push Docker image to ECR.
  5. Deploy to Kubernetes.

## Notifications

Notifications are sent to `ihartsykala24@gmail.com` on pipeline success or failure.
