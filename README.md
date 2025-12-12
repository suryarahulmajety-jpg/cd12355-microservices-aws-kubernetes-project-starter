# Coworking Space Analytics Microservice - Deployment Guide

This repository contains the Dockerized analytics microservice and Kubernetes deployment files used to operationalize the coworking analytics service. The system uses AWS ECR for image storage, AWS CodeBuild for CI, and Amazon EKS for deployment.

## Deployment Flow
1. Developer commits code → GitHub
2. CodeBuild auto-builds Docker image → pushes to ECR
3. Kubernetes Deployment pulls new image → application runs on EKS
4. CloudWatch Container Insights provides logging

## How to deploy changes
- Update code → push to GitHub
- CodeBuild tags a new version (semantic tagging recommended)
- Update deployment image tag and apply:
  `kubectl apply -f deployments/`

