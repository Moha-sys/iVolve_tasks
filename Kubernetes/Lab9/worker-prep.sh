#!/bin/bash
set -e

echo "=========================================================="
echo " Step 1: Install conntrack-tools if missing"
echo "=========================================================="
if ! command -v conntrack &> /dev/null; then
    sudo dnf install -y conntrack-tools
fi

echo "=========================================================="
echo " Step 2: Set Worker Hostname to 'worker1'"
echo "=========================================================="
sudo hostnamectl set-hostname worker1
if ! grep -q "worker1" /etc/hosts; then
    echo "127.0.0.1 worker1" | sudo tee -a /etc/hosts
fi

echo "=========================================================="
echo " Step 3: Regenerate Machine ID (Ensures unique DHCP IP)"
echo "=========================================================="
sudo rm -f /etc/machine-id
sudo systemd-machine-id-setup

echo "=========================================================="
echo " Step 4: Restart Network & Kubelet"
echo "=========================================================="
sudo systemctl restart NetworkManager || sudo systemctl restart systemd-networkd || true
sudo systemctl enable --now kubelet

echo ""
echo "Worker node is prepared!"
echo "Now run the 'sudo kubeadm join ...' command provided by the master node."
