#!/usr/bin/env bash
# ==============================================================================
# Lab 25: Verification Script for Docker, Kubectl, and Jenkins
# ==============================================================================
set -euo pipefail

TARGET="${1:-managed_nodes}"

echo "===================================================================="
echo " 1. Running Syntax Check on Playbook"
echo "===================================================================="
ansible-playbook playbook.yml --syntax-check

echo ""
echo "===================================================================="
echo " 2. Executing Automated DevOps Playbook with Privilege Escalation"
echo "===================================================================="
echo "[INFO] Running playbook: ansible-playbook playbook.yml -K -l ${TARGET}"
ansible-playbook playbook.yml --ask-become-pass -l "${TARGET}"

echo ""
echo "===================================================================="
echo " 3. Running Remote Ad-Hoc Verification Commands"
echo "===================================================================="
echo "--- Docker Engine Verification ---"
ansible "${TARGET}" -m command -a "docker --version"
ansible "${TARGET}" -m command -a "docker ps"

echo ""
echo "--- Kubectl CLI Verification ---"
ansible "${TARGET}" -m command -a "kubectl version --client"

echo ""
echo "--- Jenkins Service Verification ---"
ansible "${TARGET}" -m command -a "systemctl status jenkins" || true
ansible "${TARGET}" -m uri -a "url=http://localhost:8080/login status_code=200" || true
