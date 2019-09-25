#!/bin/bash

# Include vars
source /vagrant/provisioning/vars.sh

echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=172.42.42.100 --pod-network-cidr=10.244.0.0/16 --kubernetes-version=${KUBERNETES_VERSION} >> /root/kubeinit.log 2>/dev/null

echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

echo "[TASK 3] Deploy flannel network"
su - vagrant -c "kubectl create -f /vagrant/networking/kube-flannel.yml"

echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh
