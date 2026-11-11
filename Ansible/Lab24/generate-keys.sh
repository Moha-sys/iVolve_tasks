#!/usr/bin/env bash
# ==============================================================================
# Lab 24: Generate SSH Key & Transfer to Managed Node
# ==============================================================================
set -euo pipefail

KEY_PATH="${HOME}/.ssh/id_rsa"
MANAGED_USER="${1:-moha}"
MANAGED_HOST="${2:-192.168.1.61}"

echo "===================================================================="
echo " 1. Generating RSA 4096-bit SSH Key Pair on Control Node"
echo "===================================================================="
if [[ -f "${KEY_PATH}" ]]; then
    echo "[INFO] SSH key already exists at: ${KEY_PATH}"
else
    ssh-keygen -t rsa -b 4096 -f "${KEY_PATH}" -N "" -C "ansible-control-node"
    echo "[SUCCESS] Generated key pair: ${KEY_PATH} and ${KEY_PATH}.pub"
fi

echo ""
echo "===================================================================="
echo " 2. Transferring Public Key to Managed Node (${MANAGED_USER}@${MANAGED_HOST})"
echo "===================================================================="
echo "[INFO] Running ssh-copy-id..."
ssh-copy-id -i "${KEY_PATH}.pub" "${MANAGED_USER}@${MANAGED_HOST}"

echo ""
echo "===================================================================="
echo " 3. Validating Passwordless Authentication"
echo "===================================================================="
ssh -i "${KEY_PATH}" -o BatchMode=yes "${MANAGED_USER}@${MANAGED_HOST}" "hostname && uptime"
echo "[SUCCESS] Passwordless SSH access confirmed!"
