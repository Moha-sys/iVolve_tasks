# Ansible Automation Module (RH294)

Welcome to the **Red Hat Enterprise Linux Automation with Ansible (RH294)** module of the iVolve Training Program.

This module provides hands-on implementation of enterprise automation patterns, progressing from basic configuration and ad-hoc commands to modular roles, sensitive data encryption with Ansible Vault, and cloud-native dynamic host discovery.

---

## Labs in this Module

| Lab | Title | Description | Directory |
| :--- | :--- | :--- | :--- |
| **Lab 24** | **Initial Ansible Configuration and Ad-Hoc Execution** | Control node installation, RSA 4096-bit key pair distribution via `ssh-copy-id`, static inventory management, and Docker ad-hoc package execution. | [Lab 24 Documentation](Lab24/README.md) |
| **Lab 25** | **Automated Web Server Configuration Using Playbooks** | End-to-end automation playbook installing and verifying Docker CE, architecture-aware Kubectl binary, and Jenkins CI server with Java 17 LTS. | [Lab 25 Documentation](Lab25/README.md) |
| **Lab 26** | **Structured Configuration Management with Roles** | Enterprise-grade refactoring into reusable, tagged roles for `docker`, `kubectl`, and `jenkins` with handlers and separate variable scopes. | [Lab 26 Documentation](Lab26/README.md) |
| **Lab 27** | **Securing Sensitive Data with Ansible Vault** | Deploying MySQL/MariaDB role, creating database `ivovle` and user `ivolveuser`, and securing credentials using AES-256 Ansible Vault encryption. | [Lab 27 Documentation](Lab27/README.md) |
| **Lab 28** | **Automated Host Discovery with Dynamic Inventory** | AWS EC2 automated discovery via `amazon.aws.aws_ec2` plugin, filtering instances by tag `server:ivolve`, inventory graphing, and automated web server rollout. | [Lab 28 Documentation](Lab28/README.md) |
