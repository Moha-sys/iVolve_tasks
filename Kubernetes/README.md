# ☸️ Orchestration with Kubernetes

This directory contains tasks, labs, and manifests completed for the **Kubernetes** module of the NTI training program.

---

## Completed Labs

| Lab | Description | Documentation |
| :--- | :--- | :--- |
| **Lab 9** | Deploying a multi-node Kubernetes cluster across two Virtual Machines using Kubeadm and Calico CNI. | [Lab 9 Documentation](Lab9/README.md) |
| **Lab 10** | Node Isolation Using Taints and Labels in Kubernetes (`workload=ivolveApp:NoSchedule` and `project=ivolve`). | [Lab 10 Documentation](Lab10/README.md) |
| **Lab 11** | Namespace Management (`ivolve`) and Resource Quota Enforcement (`ivolvequota` limiting pods to 3). | [Lab 11 Documentation](Lab11/README.md) |
| **Lab 12** | Managing Configuration and Sensitive Data with ConfigMaps (`ivolvecm` / `db-config`) and Base64 Secrets (`ivolvesecret` / `db-secret`). | [Lab 12 Documentation](Lab12/README.md) |
| **Lab 13** | Persistent Storage Setup for Application Logging (`hostPath` PV `logs-pv`/`ivolvepv` and PVC `pvc-app-logs`/`ivolvepvc` with `ReadWriteMany`). | [Lab 13 Documentation](Lab13/README.md) |
| **Lab 14** | StatefulSet (`ivolvedb`) with Headless Service (`mysql-service`/`ivolvedbsvc`), node isolation, and DNS resolution. | [Lab 14 Documentation](Lab14/README.md) |
| **Lab 15** | Node.js Application Deployment with Private Registry Secret (`dockerhub-cred`), InitContainer MySQL bootstrap, and ClusterIP Service (`ivolveappsvc`). | [Lab 15 Documentation](Lab15/README.md) |
| **Lab 16** | Pod Resource Management with CPU and Memory Requests (`1 CPU`, `1Gi`) and Limits (`2 CPU`, `2Gi`), and Metrics Server monitoring. | [Lab 16 Documentation](Lab16/README.md) |
| **Lab 17** | Control Pod-to-Pod Traffic via NetworkPolicy (`ivolvenp` / `allow-app-to-mysql`) restricting MySQL ingress on TCP port 3306. | [Lab 17 Documentation](Lab17/README.md) |
| **GatewayAPI** | Modern Kubernetes Gateway API implementation (`Gateway` + `HTTPRoute`) via NGINX Gateway Fabric. | [Gateway API Documentation](GatewayAPI/README.md) |
