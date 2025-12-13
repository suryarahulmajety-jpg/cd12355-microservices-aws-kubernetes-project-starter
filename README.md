# Coworking Space Service – Analytics Extension (EKS)

## Overview

The Coworking Space Service is a microservice-based application that allows users to request one-time access tokens and enables administrators to authorize access to a coworking space.  
This repository focuses on the **Analytics Service**, which exposes APIs used by business analysts to retrieve usage metrics such as daily visits and user-based activity.

In this project, I worked as a **DevOps engineer**, responsible for containerizing the analytics application, building a CI/CD pipeline, and deploying the service into a **Kubernetes environment on AWS EKS**.

---

## System Architecture

The system follows a cloud-native, microservice-oriented design:

- **Analytics API**
  - Python (Flask) application
  - Containerized using Docker
  - Deployed as a Kubernetes Deployment
- **Database**
  - PostgreSQL deployed using a Bitnami Helm chart
  - Runs inside the same Kubernetes cluster
- **Container Registry**
  - Amazon ECR stores versioned Docker images
- **CI/CD Pipeline**
  - GitHub triggers AWS CodeBuild via webhook
  - CodeBuild builds and pushes Docker images to ECR
- **Orchestration & Runtime**
  - Amazon EKS manages application and database workloads
- **Observability**
  - Application logs available via Kubernetes
  - Infrastructure and build logs available in CloudWatch

An architecture diagram is included in the submission to illustrate component interactions.

---

## Technology Stack

- Python (Flask)
- Docker
- Kubernetes
- Helm
- Amazon EKS
- Amazon ECR
- AWS CodeBuild
- AWS CloudWatch
- GitHub Webhooks

---

## CI/CD Workflow

The deployment pipeline is fully automated and GitHub-driven:

1. A code change is pushed to the GitHub repository.
2. A GitHub webhook triggers an AWS CodeBuild project.
3. CodeBuild:
   - Builds the Docker image using `buildspec.yml`
   - Tags the image with a build-based version
   - Pushes the image to Amazon ECR
4. The Kubernetes deployment references the updated image from ECR.
5. Pods are recreated automatically by Kubernetes using a rolling update strategy.

This workflow ensures consistent, repeatable, and auditable deployments.

---

## Kubernetes Deployment Strategy

All Kubernetes manifests used for deployment are stored in the `deployments/` directory:

- `deployment.yaml` – Analytics application deployment
- `configmap.yaml` – Runtime configuration
- `secret.yaml` – Database credentials
- PostgreSQL deployed via Helm

The application uses:
- Liveness and readiness probes for health checks
- ConfigMaps and Secrets for environment configuration
- ClusterIP services for internal communication

---

## Application Logging & Observability

The analytics service continuously queries the database and logs runtime information, including query execution and health checks.

### Log Collection Approach

Application logs are retrieved using:

```bash
kubectl logs -l app=coworking
