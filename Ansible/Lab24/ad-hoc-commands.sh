#!/usr/bin/env bash
# ==============================================================================
# Lab 24: Ansible Ad-Hoc Commands Execution
# ==============================================================================
set -euo pipefail

TARGET="${1:-managed_nodes}"

echo "===================================================================="
echo " Step 1: Ad-Hoc Connectivity Check (ping module)"
echo "===================================================================="
ansible "${TARGET}" -m ping

echo ""
echo "===================================================================="
echo " Step 2: Ad-Hoc Command - Add Docker Official Repository"
echo "===================================================================="
ansible "${TARGET}" -b -m get_url -a \
    "url=https://download.docker.com/linux/rhel/docker-ce.repo dest=/etc/yum.repos.d/docker-ce.repo mode=0644" \
    --ask-become-pass

echo ""
echo "===================================================================="
echo " Step 3: Ad-Hoc Command - Install Docker Packages (package module)"
echo "===================================================================="
ansible "${TARGET}" -b -m package -a \
    "name=docker-ce,docker-ce-cli,containerd.io,docker-buildx-plugin,docker-compose-plugin state=present" \
    --ask-become-pass

echo ""
echo "===================================================================="
echo " Step 4: Ad-Hoc Command - Start & Enable Docker Service (service module)"
echo "===================================================================="
ansible "${TARGET}" -b -m service -a \
    "name=docker state=started enabled=yes" \
    --ask-become-pass

echo ""
echo "===================================================================="
echo " Step 5: Ad-Hoc Command - Verify Docker Installation (command module)"
echo "===================================================================="
ansible "${TARGET}" -m command -a "docker --version"
ansible "${TARGET}" -m command -a "docker info"
