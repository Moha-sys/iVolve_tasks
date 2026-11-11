#!/usr/bin/env bash
# ==============================================================================
# Lab 28: Dynamic Inventory Discovery & Execution Verification
# ==============================================================================
set -euo pipefail

INVENTORY="${1:-aws_ec2.yaml}"

echo "===================================================================="
echo " 1. Validating Dynamic Inventory with 'ansible-inventory --graph'"
echo "===================================================================="
ansible-inventory -i "${INVENTORY}" --graph

echo ""
echo "===================================================================="
echo " 2. Listing Inventory Hosts with 'ansible-inventory --list'"
echo "===================================================================="
ansible-inventory -i "${INVENTORY}" --list | head -n 30
echo "... (truncated for readability)"

echo ""
echo "===================================================================="
echo " 3. Testing Host Connectivity (Ping Module)"
echo "===================================================================="
ansible tag_server_ivolve -i "${INVENTORY}" -m ping || true

echo ""
echo "===================================================================="
echo " 4. Executing Configuration Playbook on Discovered EC2"
echo "===================================================================="
ansible-playbook -i "${INVENTORY}" playbook.yml || true

echo ""
echo "===================================================================="
echo " 5. Dynamic Inventory Verification Completed"
echo "===================================================================="
