#!/usr/bin/env bash
# ==============================================================================
# Lab 27: Validate MySQL Database & User Credentials
# Connects to MySQL using 'ivolveuser' and checks access to 'ivovle' database
# ==============================================================================
set -euo pipefail

TARGET="${1:-managed_nodes}"
DB_USER="ivolveuser"
DB_PASS="IvolveSecurePassword2026!"
DB_NAME="ivovle"

echo "===================================================================="
echo " 1. Running Playbook with Decrypted Ansible Vault Credentials"
echo "===================================================================="
ansible-playbook playbook.yml --ask-become-pass -l "${TARGET}"

echo ""
echo "===================================================================="
echo " 2. Validating MySQL Connection Directly on Managed Node (${TARGET})"
echo "===================================================================="
echo "[INFO] Connecting as user: ${DB_USER} to list databases..."
ansible "${TARGET}" -m command -a \
    "mysql -u ${DB_USER} -p'${DB_PASS}' -h 127.0.0.1 -e 'SHOW DATABASES;'"

echo ""
echo "===================================================================="
echo " 3. Validating Permissions on '${DB_NAME}' Database"
echo "===================================================================="
ansible "${TARGET}" -m command -a \
    "mysql -u ${DB_USER} -p'${DB_PASS}' -h 127.0.0.1 -e 'SHOW GRANTS FOR CURRENT_USER();'"

echo ""
echo "[SUCCESS] Database '${DB_NAME}' and user '${DB_USER}' validated successfully!"
