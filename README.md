Coworking Space Analytics App 

Hi! This repo contains my submission for the *Udacity Cloud Developer Nanodegree — Microservices on AWS with Kubernetes* final project.  
This app exposes analytics APIs (daily usage + user visits) and runs fully on **Amazon EKS**, using:

- ECR (Docker image registry)
- EKS (Kubernetes cluster)
- Helm (for PostgreSQL)
- CodeBuild (CI build + Docker push)
- LoadBalancer service (public access)

 1. Project Overview

This project is a simple analytics microservice written in Python (Flask).  
It connects to **PostgreSQL**, fetches seeded data, and exposes two API endpoints:

- `/api/reports/daily_usage`  
- `/api/reports/user_visits`

The backend runs inside a Docker container deployed on AWS EKS

Docker Build & Push Steps

```sh
docker build -t coworking-app:1.0.0 -f analytics/Dockerfile .
```

Tag it for ECR

```sh
docker tag coworking-app:1.0.0 \
522062037927.dkr.ecr.us-east-1.amazonaws.com/coworking-space:1.0.0
```

Login to ECR

```sh
aws ecr get-login-password --region us-east-1 \
| docker login --username AWS \
  --password-stdin 522062037927.dkr.ecr.us-east-1.amazonaws.com
```

Push image

```sh
docker push 522062037927.dkr.ecr.us-east-1.amazonaws.com/coworking-space:1.0.0
```

---

PostgreSQL Setup on Kubernetes

Deployed Postgres in EKS using the Bitnami Helm chart

```sh
helm install coworking-db bitnami/postgresql \
  --set auth.username=rahul \
  --set auth.password=Welcome_123 \
  --set auth.database=coworking \
  --set persistence.enabled=false \
  --set primary.persistence.enabled=false \
  --set readReplicas.persistence.enabled=false
```

Verify the DB pod is running

```sh
kubectl get pods -l app.kubernetes.io/name=postgresql
```

Port-forward to access PostgreSQL locally

```sh
kubectl port-forward svc/coworking-db-postgresql 5432:5432
```

Connect using psql 

```sh
psql -h 127.0.0.1 -U rahul -d coworking
```

---

Database Seeding

The `db/seed.sql` file contains test analytics + visit data.

To seed the DB:

```sh
kubectl run pg-client --rm -it --image=postgres:14 -- bash
```

Inside the pod:

```sh
psql -h coworking-db-postgresql -U rahul -d coworking -f /seed/seed.sql
```
 Kubernetes Deployment Manifests

The Kubernetes YAMLs used in this project are stored under:

```
deployments/configmap.yaml
deployments/secret.yaml
deployments/deployment.yaml
```

Apply them:

```sh
kubectl apply -f deployments/configmap.yaml
kubectl apply -f deployments/secret.yaml
kubectl apply -f deployments/deployment.yaml
``'
```

The app exposes a **LoadBalancer** service that looks like:

```
a88b75e05bb1d40d58f9904edb74c893-xxxxxxxx.elb.amazonaws.com
```

