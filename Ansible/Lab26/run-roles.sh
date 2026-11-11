#!/usr/bin/env bash
# ==============================================================================
# Lab 26: Execute Master Roles Playbook
# ==============================================================================
set -euo pipefail

TARGET="${1:-managed_nodes}"
TAGS="${2:-all}"

echo "===================================================================="
echo " 1. Validating Role Structure and Playbook Syntax"
echo "===================================================================="
ansible-playbook site.yml --syntax-check

echo ""
echo "===================================================================="
echo " 2. Executing Playbook (Target: ${TARGET}, Tags: ${TAGS})"
echo "===================================================================="
if [[ "${TAGS}" == "all" ]]; then
    ansible-playbook site.yml --ask-become-pass -l "${TARGET}"
else
    ansible-playbook site.yml --ask-become-pass -l "${TARGET}" --tags "${TAGS}"
fi

echo ""
echo "===================================================================="
echo " 3. Role Execution Completed Successfully"
echo "===================================================================="
