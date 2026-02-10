🚀 GKE CI/CD with Terraform, Docker, Helm & GitHub Actions

This repository demonstrates an end-to-end DevOps pipeline for deploying a containerized Node.js application to Google Kubernetes Engine (GKE) using:

Terraform for infrastructure provisioning

Docker for containerization

GitHub Actions for CI/CD

Helm for Kubernetes deployments

Trivy for image vulnerability scanning

GCP Secret Manager for secrets

Cloud Monitoring for observability

🏗️ Architecture Overview
Developer → GitHub → GitHub Actions
                 ├─ Build Docker Image
                 ├─ Scan Image (Trivy)
                 ├─ Push to GCR
                 └─ Deploy to GKE (Helm)


Infrastructure is provisioned once using Terraform, while application deployments are fully automated via CI/CD.

📁 Repository Structure
.
├── terraform/                 # GKE infrastructure (Terraform)
├── helm/hello-world/          # Helm chart for the app
├── Dockerfile                 # Container build
├── package.json               # Node.js dependencies
├── index.js                   # Sample Express app
└── .github/workflows/
    └── ci-cd-gke.yaml          # GitHub Actions pipeline

⚙️ Prerequisites

Google Cloud Project

GKE & required APIs enabled

Terraform ≥ 1.4

Docker

Helm ≥ 3.x

GitHub repository with Actions enabled

🔐 Required GitHub Secrets

Configure the following secrets in GitHub → Settings → Secrets → Actions:

Secret Name	Description
GCP_PROJECT_ID	GCP Project ID
GCP_SA_KEY	Service Account JSON key
Required IAM Roles for Service Account

roles/container.admin

roles/storage.admin or roles/artifactregistry.writer

roles/secretmanager.secretAccessor

1️⃣ Infrastructure Provisioning (Terraform)
cd terraform
terraform init
terraform apply


This provisions:

GKE cluster

Managed node pool

HTTP Load Balancing

Cloud Monitoring (Managed Prometheus)

2️⃣ Application Containerization (Docker)

The application is a simple Node.js + Express service.

docker build -t hello-world .

3️⃣ CI/CD Pipeline (GitHub Actions)

The pipeline automatically triggers on every push to main and performs:

Authenticate to GCP

Build Docker image

Scan image with Trivy

Push image to GCR

Authenticate to GKE

Deploy using Helm

📄 Workflow file:

.github/workflows/ci-cd-gke.yaml


Security note:

The pipeline fails automatically if HIGH or CRITICAL vulnerabilities are detected.

4️⃣ Kubernetes Deployment (Helm)

Helm is used instead of raw Kubernetes manifests for:

Reusability

Configurability

Production best practices

Deployment command used by CI:

helm upgrade --install hello-world helm/hello-world \
  --set image.repository=gcr.io/<PROJECT_ID>/hello-world

🔐 Secrets Management

Secrets are stored securely in GCP Secret Manager and injected into Kubernetes as environment variables.

No secrets are stored in:

GitHub

Docker images

Helm values

📊 Monitoring & Observability

Enabled via GKE:

Pod CPU / memory metrics

Node health

Logs in Cloud Logging

Metrics in Cloud Monitoring

This provides out-of-the-box observability without additional tooling.

🌐 Accessing the Application

After deployment:

kubectl get svc hello-world


Example output:

NAME          TYPE           EXTERNAL-IP
hello-world  LoadBalancer   34.xxx.xxx.xxx


Application URL:

http://34.xxx.xxx.xxx
