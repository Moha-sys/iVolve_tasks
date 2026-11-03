# iVolve_tasks

A collection of hands-on tasks, labs, and projects completed during the NTI On-the-Job Training (OJT) program at iVolve.

---

## 🛠️ Build Tools

| Lab | Tool | Description | Documentation |
| :--- | :--- | :--- | :--- |
| **Lab 1** | Maven | Building and packaging a Java application with Maven, running unit tests, and verifying the executable JAR artifact. | [Lab 1 Documentation](Build%20Tools/Lab1/README.md) |
| **Lab 2** | Gradle | Building and packaging a Java application with Gradle, running JUnit 5 tests, and generating the distribution JAR. | [Lab 2 Documentation](Build%20Tools/Lab2/README.md) |

---

## 🐳 Containerization with Docker

| Lab | Focus | Description | Documentation |
| :--- | :--- | :--- | :--- |
| **Lab 3** | Dockerfiles & Multi-approach Build | Building Java app Docker images using two approaches (Build inside Docker with Maven vs Build locally with JRE runtime), non-root user security, and image size comparison. | [Lab 3 Documentation](Docker/Lab3/README.md) |
| **Lab 4** | Image Optimization & Export/Load | Optimizing Docker images with multi-stage builds, non-root user hardening, size comparison, and backup/restore with `docker save` & `docker load`. | [Lab 4 Documentation](Docker/Lab4/README.md) |
| **Lab 5** | Vulnerability Scanning & Remediation | Vulnerability scanning with Trivy, HIGH & CRITICAL severity filtering, HTML reporting, and comprehensive vulnerability remediation eliminating all CVEs. | [Lab 5 Documentation](Docker/Lab5/README.md) |
| **Lab 6** | Environment Variables & Resources | Configuring environment variables via CLI flags, env files, and Dockerfiles; enforcing CPU & memory constraints (`docker stats`). | [Lab 6 Documentation](Docker/Lab6/README.md) |
| **Lab 7** | Multi-Network Microservices & Storage | Multi-network microservices (`frontend-backend` & `backend-notification`), dual-homed backend, named volumes, and host bind mounts. | [Lab 7 Documentation](Docker/Lab7/README.md) |
| **Lab 8** | Docker Compose Stack | Multi-container Node.js and MySQL application with Docker Compose, automated database initialization, health probes, and Docker Hub release. | [Lab 8 Documentation](Docker/Lab8/README.md) |

---

## ☸️ Orchestration with Kubernetes

| Lab | Focus | Description | Documentation |
| :--- | :--- | :--- | :--- |
| **Lab 9** | Multi-Node Cluster with Kubeadm | Deploying a multi-node Kubernetes cluster across two Virtual Machines using Kubeadm and Calico CNI. | [Lab 9 Documentation](Kubernetes/Lab9/README.md) |
| **Lab 10** | Node Isolation (Taints & Labels) | Enforcing node isolation with taints (`workload=ivolveApp:NoSchedule`), labels (`project=ivolve`), and tolerations. | [Lab 10 Documentation](Kubernetes/Lab10/README.md) |
| **Lab 11** | Namespaces & ResourceQuotas | Namespace management (`ivolve`) and enforcing hard pod resource limits (`ivolvequota`). | [Lab 11 Documentation](Kubernetes/Lab11/README.md) |
| **Lab 12** | ConfigMaps & Secrets | Managing application configuration (`ivolvecm` / `db-config`) and Base64 sensitive credentials (`ivolvesecret` / `db-secret`). | [Lab 12 Documentation](Kubernetes/Lab12/README.md) |
| **Lab 13** | Persistent Storage & Volumes | Provisioning PersistentVolumes (`logs-pv` / `ivolvepv`) and PersistentVolumeClaims (`pvc-app-logs` / `ivolvepvc`) for application logging. | [Lab 13 Documentation](Kubernetes/Lab13/README.md) |
| **Lab 14** | StatefulSets & Headless Services | Deploying MySQL StatefulSet (`ivolvedb`) with headless service (`mysql-service` / `ivolvedbsvc`), node isolation, volume templates, and DNS verification. | [Lab 14 Documentation](Kubernetes/Lab14/README.md) |
| **Lab 15** | Application Deployment & InitContainers | Node.js application deployment with private Docker Hub pull secret (`dockerhub-cred`), MySQL setup initContainer, and ClusterIP service (`ivolveappsvc`). | [Lab 15 Documentation](Kubernetes/Lab15/README.md) |
| **Lab 16** | Resource Management (Requests & Limits) | Setting strict CPU/memory requests (`1 CPU`, `1Gi`) and limits (`2 CPU`, `2Gi`), with cluster Metrics Server monitoring (`top pod`). | [Lab 16 Documentation](Kubernetes/Lab16/README.md) |
| **Lab 17** | Pod-to-Pod Traffic Security (NetworkPolicy) | Enforcing zero-trust network policy (`ivolvenp` / `allow-app-to-mysql`) restricting MySQL database ingress to application pods on TCP port 3306. | [Lab 17 Documentation](Kubernetes/Lab17/README.md) |
| **Lab 18** | Node-Wide Pod Management & Monitoring | Deploying Prometheus node-exporter as a DaemonSet across all nodes, Alertmanager, Prometheus server, and Grafana in dedicated `monitoring` namespace. | [Lab 18 Documentation](Kubernetes/Lab18/README.md) |
| **Lab 19** | RBAC & Service Accounts Security | Configuring Kubernetes ServiceAccount (`jenkinssa`), long-lived token, Role (`ivolveDeployRole`), and RoleBinding (`ivolveDeployRoleBinding`) with least-privilege deployment permissions. | [Lab 19 Documentation](Kubernetes/Lab19/README.md) |
| **GatewayAPI** | Kubernetes Gateway API | Deploying modern Gateway API (`Gateway` + `HTTPRoute`) via NGINX Gateway Fabric controller to expose the application externally. | [Gateway API Documentation](Kubernetes/GatewayAPI/README.md) |
