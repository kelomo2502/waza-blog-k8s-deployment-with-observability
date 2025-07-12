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
├── blog-app/                 # React frontend (Vite)
├── metrics-backend/         # Node.js metrics API
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

### Phase 2: Kubernetes - Local Deployment

- Create Kubernetes manifests for frontend (Deployment, Service, Ingress)
- Create Kubernetes manifests for metrics backend
- Configure Prometheus and Grafana with dashboards for metrics
- Enable TLS and external access using Ingress + Ngrok or local DNS
- Add ConfigMap or env injection for frontend to reference backend via K8s service name
