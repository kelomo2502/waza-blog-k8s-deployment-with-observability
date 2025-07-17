# Project Goals

**To build, deploy, and maintain a cloud-native, observable, production-grade application stack (Waza App) using:**

- IaC (Terraform)
- Kubernetes (Minikube → EKS)
- Observability (Prometheus, Grafana, Alertmanager)
- Security (Secrets, Role-based Access Control, TLS, Image Scanning)
- DevOps Best Practices (GitOps, version control, tagging, modularization)

## Overall Project Structure

```md
waza-app/
├── waza-app/                 # React frontend (Vite)
├── metrics-app/         # Node.js metrics API
├── docker-compose.yaml
├── k8s/                     # Kubernetes manifests
│   ├── base/                # Base manifests for kustomization
│   └── overlays/            # Environment-specific overrides
│       └── local/
│       └── dev/
│       └── prod/
├── terraform/               # Infrastructure as Code (EKS, VPC, IAM, etc.)
│   ├── modules/
│   └── environments/
│       └── dev/
│       └── prod/
├── .github/                 # GitHub Actions for CI/CD
│   └── workflows/
├── helm-charts/             # If we use Helm for packaging
├── scripts/                 # Utility scripts
└── docs/                    # Documentation and architecture diagrams

```

## Step-by-Step Roadmap

### Phase 1: Local Dev & Containerization (✅ Already Completed)

- Containerize blog frontend with dynamic env-config.js using entrypoint.sh
- Containerize metrics backend with Express + Prometheus metrics
- Test both containers using Docker Compose

### Phase 2: Kubernetes -  Deployment

- Create Kubernetes manifests for frontend (Deployment, Service, Ingress)
- Create Kubernetes manifests for metrics backend
- Configure Prometheus and Grafana with dashboards for metrics
- Enable TLS and external access using Ingress + Ngrok or local DNS
- Add ConfigMap or env injection for frontend to reference backend via K8s service name

### Phase 3: Infrastructure as Code with Terraform

**Build Terraform modules for:**

- VPC
- EKS Cluster
- IAM Roles
- Node Groups
- S3/DynamoDB for remote state
- Use terragrunt or terraform workspace for managing environments
- Store state in S3 + DynamoDB (already partially done)

### Phase 4: CI/CD Pipeline

**GitHub Actions:**

- Lint & test on PRs
- Build & push Docker images to Docker Hub or ECR
- Deploy to Kubernetes using kubectl or Helm
- Setup preview environments on PR using kustomize overlays
- Add secrets management with GitHub Actions + SOPS (or external secret manager)

### Phase 5: Observability & Monitoring

**Prometheus setup with scrape configs for metrics backend:**

- Grafana dashboards (login/signup/page load metrics)
- Alertmanager with email or Slack integration
- Log aggregation with Loki or Fluent Bit

### Phase 6: Production Readiness

- Secure HTTPS Ingress with cert-manager
- RBAC policies for namespace isolation
- Readiness/liveness probes in all deployments
- Image scanning with Trivy/GitHub Dependabot
- Backup strategy for data & configuration

### Daily Dev Flow

`Feature Branch → PR → CI → Merge`
`docker-compose up for local dev`
`kubectl apply -k overlays/local for local K8s testing`
`Push → GitHub Actions → Deploy to cluster`
`Monitor via Grafana & Prometheus`

## Outputs

````dsl
cluster_name = "waza-app-eks"
kubeconfig = {
  "certificate" = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJWHRqOEtmSTVWR013RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRBM01UUXhNekl6TkROYUZ3MHpOVEEzTVRJeE16STRORE5hTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURCQkVCdHdrMjI3clhjeTkzd1FxN2lJWXA2cEF2RDl4MDNjSGtLejlCRkFwNE1MZlNMZ0tITTR4Z2UKVjhZdE5PaXJKNW1LK3JqTXp6eFIxTFNDZUpzQ2ltekU2R2kvYWIvS1dIUnRnZ001YzQ2SzVqMWR5V0YvS3piawp2eUkzUk5DOG1SQTBrRVZsYWNiVWN6TGtmdEdOTXhYS0NHQmJwcDNHUGt1SWVkY0dsLzVkRTNkK0Fac21EbmE2CmlzN2gyVzlLL3AzYmJhbHpKdU1zMXY0bERyekhOVWZ1VnhTbU1EamF6aE5VK1cybEJuY0t3ZjgrWjFKUExFSkUKelVra3I0ejU4RnJuT1QrWHhVaDZZRDVWYUVKVzNmM0RSZ3lEWVNoamxLem5sNmFMb1hLSC9DSjVGVFcyNnBodApGcnBTZjlQcGxSRm1mREVTajdIWUkrK2U2TUR2QWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJUYXFyMGh0SVhOb1BEK3F5YzJGVktlZG4zTXhqQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ2lPNk5tOWlsYQpPQ2JYc0ZxT00xaW15TTI3d1NmNXVYOHp1MXRiaUZ4VWw2eTlpQTZub1p1bytNT2V2bHNyR0JZOE5RTnRNRkNQCmt5aUl6czFlbEU4eS9kWTh2c3E4VEFOYThPdkRiY3RGbi83dUN4WFdYSlRveDBqb1cxRmp1V0pJYlFIWURHYmEKdFJnSERQdUxzN1RKZnlHN01LU2Y3a2x6QTJObzNhTk10YTl0bCtHN0thUkV5OEV3bHc4N3VmRnFJVjh1NEpxNAo2bkF3MjYrM0ZFRFpMVW1wRm0yNElnRDdCTmhmOTV2NVJ3Mmg1Z0lnVXZ2V0FTRWlWNTh4dWxETFp6QS9vUnRiClRoY1BkdUlBejlQOFV2dmphVURmcFFQOXBIcDlxeWp6dHFGSVV0MEdZVXF4Tkl0WVJnbE5IUFZFaWlSZHhIQmoKN280c0JVamk2M1V1Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"
  "cluster_name" = "waza-app-eks"
  "endpoint" = "https://B90ACC1AF136930FBCBD799306B34988.gr7.us-east-1.eks.amazonaws.com"
}
```
