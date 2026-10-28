# ☸️ Orchestration with Kubernetes

This directory contains tasks, labs, and manifests completed for the **Kubernetes** module of the NTI training program.

---

## Completed Labs

| Lab | Description | Documentation |
| :--- | :--- | :--- |
| **Lab 9** | Deploying a multi-node Kubernetes cluster across two Virtual Machines using Kubeadm and Calico CNI. | [Lab 9 Documentation](Lab9/README.md) |
| **Lab 10** | Node Isolation Using Taints and Labels in Kubernetes (`workload=ivolveApp:NoSchedule` and `project=ivolve`). | [Lab 10 Documentation](Lab10/README.md) |
| **Lab 11** | Namespace Management (`ivolve`) and Resource Quota Enforcement (`ivolvequota` limiting pods to 3). | [Lab 11 Documentation](Lab11/README.md) |
| **Lab 12** | Managing Configuration and Sensitive Data with ConfigMaps (`ivolvecm`) and Base64 Secrets (`ivolvesecret`). | [Lab 12 Documentation](Lab12/README.md) |
| **Lab 13** | Persistent Storage Setup for Application Logging (`hostPath` PV `ivolvepv` and PVC `ivolvepvc` with `ReadWriteMany`). | [Lab 13 Documentation](Lab13/README.md) |
| **Lab 14** | StatefulSet (`ivolvedb`) with Headless Service (`ivolvedbsvc`), node isolation, ConfigMap/Secret injection, and DNS resolution. | [Lab 14 Documentation](Lab14/README.md) |

---

*(Future labs will be organized in their respective `LabX/` directories with dedicated `screenshots/` folders)*
