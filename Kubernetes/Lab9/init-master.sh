#!/bin/bash
set -e

# Detect current primary IP address
MASTER_IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}')
if [ -z "$MASTER_IP" ]; then
    MASTER_IP=$(hostname -I | awk '{print $1}')
fi

echo "=========================================================="
echo " Step 1: Clean up any previous cluster state (kubeadm reset)"
echo "=========================================================="
sudo kubeadm reset -f || true
sudo rm -rf /etc/cni/net.d
sudo rm -rf /var/lib/etcd
sudo rm -rf /etc/kubernetes/manifests/*
sudo rm -rf "$HOME/.kube"
sudo systemctl restart containerd
echo "Cluster reset cleanly."

echo "=========================================================="
echo " Step 2: Ensure conntrack-tools is installed"
echo "=========================================================="
if ! command -v conntrack &> /dev/null; then
    sudo dnf install -y conntrack-tools
fi

echo "=========================================================="
echo " Step 3: Set Hostname to 'master' and add to /etc/hosts"
echo "=========================================================="
sudo hostnamectl set-hostname master
if ! grep -q "master" /etc/hosts; then
    echo "127.0.0.1 master" | sudo tee -a /etc/hosts
fi
echo "Hostname set to master (IP: $MASTER_IP)"

echo "=========================================================="
echo " Step 4: Initialize Control Plane with kubeadm"
echo "=========================================================="
sudo kubeadm init \
  --apiserver-advertise-address="$MASTER_IP" \
  --pod-network-cidr=192.168.0.0/16 \
  --node-name=master

echo "=========================================================="
echo " Step 5: Configure kubectl for current user"
echo "=========================================================="
mkdir -p "$HOME/.kube"
sudo cp -f /etc/kubernetes/admin.conf "$HOME/.kube/config"
sudo chown $(id -u):$(id -g) "$HOME/.kube/config"

echo "=========================================================="
echo " Step 6: Install Calico CNI Plugin"
echo "=========================================================="
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml

echo ""
echo "=========================================================="
echo " Step 7: Worker Node Join Command"
echo "=========================================================="
echo "Copy and run the following command on your WORKER VM with sudo:"
echo ""
sudo kubeadm token create --print-join-command
echo ""
echo "=========================================================="
