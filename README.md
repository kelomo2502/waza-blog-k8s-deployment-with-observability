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


	
container="node-exporter"
endpoint="http-metrics"
instance="192.168.49.2:9100"
job="node-exporter"
namespace="monitoring"
pod="prometheus-prometheus-node-exporter-5m97t"
service="prometheus-prometheus-node-exporter"
1m 33.14s ago
40ms
up

serviceMonitor/waza-dev/waza-metrics-servicemonitor/0

1 / 1 up

Endpoint	Labels	Last scrape	State
http://10.244.0.34:3000/metrics
container="waza-metrics"
endpoint="http"
instance="10.244.0.34:3000"
job="waza-metrics"
namespace="waza-dev"
pod="waza-metrics-7d88896484-nqvt4"
service="waza-metrics"
1m 42.352s ago
1ms
up
