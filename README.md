# Architecture Image

![alt text](https://github.com/ankushv93/super-service-app/blob/master/eks-architecture.png)


# Super Service .NET Application - DevOps Interview Task

This project demonstrates how to deploy a new .NET Core Web API application using a Docker container and Kubernetes on a local KIND cluster.

---

## Task Requirements

The primary goals were:

1. **Run automated tests**  
2. **Package the application as a Docker image**  
3. **Deploy and run the image locally or in a public cloud**

Additional improvements such as security hardening and deployment automation were encouraged.

---

## Solution Overview

### 1. Automated Testing

- Unit tests are included under the [`./test`] folder, at the same level as the application source [`./src`].
- The Docker build process runs `dotnet test` before packaging to ensure code quality.
- The PowerShell deployment script `Deploy.ps` runs tests before building the Docker image, stopping on failure.

### 2. Docker Image Packaging

- Multi-stage Dockerfile for efficient builds:
  - Uses `mcr.microsoft.com/dotnet/sdk` for build and test stage.
  - Uses `mcr.microsoft.com/dotnet/aspnet` for the runtime image.
- Builds a lightweight, production-ready image tagged with the repository and tag.

### 3. Deployment

- Kubernetes manifests (Deployment, Service, HPA) are located in the [`./deployment_yaml`] folder.
- Deployment can be done via:
  - **Terraform** (existing infrastructure-as-code solution),
  - **PowerShell script** `Deploy.ps` for local KIND cluster deployment, or
  - **Helm charts**, which can be added as an alternative method for templated, reusable deployments.
- The PowerShell script handles image build, push to DockerHub, Kubernetes manifest apply, and port forwarding for easy local testing.
  
---

## Security Improvements

- Kubernetes Deployment manifest includes a **security context**:
  - Runs containers as non-root user (`runAsUser: 1000`).
  - Drops all Linux capabilities.
  - Defines CPU and memory resource requests/limits for cluster stability.
  - Enables HTTPS redirection in the .NET application.
- These improve security posture and resource efficiency.

---

## Pre-Requisites

- [Docker Desktop](https://docs.docker.com/desktop/mac/install/) (for building and pushing images)
- [Kubernetes Kind](https://kind.sigs.k8s.io/) (for local Kubernetes cluster)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [PowerShell 7+](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos)
- Terraform v1.0.9+ (if using the Terraform deployment path)
- Helm 3.x (for optional metrics-server or ingress controller deployments)

---

## Deploy Instruction

### Option 1: Using PowerShell Deployment Script (Local KIND Cluster)

git clone https://github.com/ankushv93/super-service-app.git

```powershell
pwsh deploy.ps
```

### This will:

- Run unit tests  
- Build and tag the Docker image  
- Push image to DockerHub  
- Deploy Kubernetes manifests to KIND cluster  
- Port-forward service to `localhost:8080` for local testing  

Test the API by opening [http://localhost:8080/time](http://localhost:8080/time) in your browser or via curl.

---

### Option 2: Using Terraform (Cloud or Local Deployment)

Terraform handles infrastructure provisioning and app deployment using existing modules:

```bash
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
```

### Terraform deploys:

- Networking stack (VPC, subnets, etc.)  
- EKS Cluster with node pools  
- Nginx ingress controller using Helm 3  
- Application deployment manifests  

---

### Additional Notes

- The solution embraces **Infrastructure as Code** principles with Terraform for scalability.  
- The PowerShell script offers a simple local deployment alternative.  
- Security is improved via container runtime restrictions and resource management.  
- CI/CD can be integrated easily by extending `Deploy.ps` into Jenkins or GitHub Actions.  
- Metrics server and HPA included to demonstrate scaling.

### Security Considerations:

- **RBAC (Role-Based Access Control):** Ensure proper access control in the Kubernetes cluster.
- **SSL/TLS Encryption:** Use **Cert-Manager** to automate SSL certificate issuance.
- **Network Policies:** Define traffic rules between pods to isolate services and improve security.

## Monitoring Enhancements (Future Work)

- Monitoring can be enhanced by deploying Prometheus and Grafana via Helm charts.
- Adding Metrics Server enables Horizontal Pod Autoscaler (HPA) functionality.
- Integration with Datadog can be considered for centralized observability.
- These improvements would help track application health, resource usage, and scaling metrics more effectively.