#!/bin/bash
set -e

echo "=========================================================="
echo " Step 1: Install Required Dependencies (conntrack-tools)"
echo "=========================================================="
sudo dnf install -y conntrack-tools

echo "=========================================================="
echo " Step 2: Stop and disable old k3s service (free port 6443)"
echo "=========================================================="
if systemctl is-active --quiet k3s 2>/dev/null; then
    sudo systemctl stop k3s
    sudo systemctl disable k3s
    echo "k3s stopped and disabled successfully."
else
    echo "k3s is not active."
fi

echo "=========================================================="
echo " Step 3: Disable Swap (Required by Kubernetes)"
echo "=========================================================="
sudo swapoff -a
sudo sed -i '/\sswap\s/ s/^\(.*\)$/#\1/g' /etc/fstab
echo "Swap disabled."

echo "=========================================================="
echo " Step 4: Configure SELinux to Permissive"
echo "=========================================================="
sudo setenforce 0 || true
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
echo "SELinux set to permissive."

echo "=========================================================="
echo " Step 5: Disable Firewall to prevent CNI / port blocking"
echo "=========================================================="
if systemctl is-active --quiet firewalld 2>/dev/null; then
    sudo systemctl stop firewalld
    sudo systemctl disable firewalld
    echo "firewalld disabled."
fi

echo "=========================================================="
echo " Step 6: Configure Kernel Modules and Sysctl"
echo "=========================================================="
sudo tee /etc/modules-load.d/k8s.conf <<MODULES
overlay
br_netfilter
MODULES

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/k8s.conf <<SYSCTL
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
SYSCTL

sudo sysctl --system

echo "=========================================================="
echo " Step 7: Configure Containerd Runtime (Enable CRI & SystemdCgroup)"
echo "=========================================================="
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd
echo "containerd configured and active."

echo "=========================================================="
echo " Step 8: Enable Kubelet Service"
echo "=========================================================="
sudo systemctl enable kubelet
echo "Kubelet enabled."

echo ""
echo ">>> All common prerequisites are READY!"
echo ">>> You can now safely create your Linked Clone VM for the Worker Node!"
