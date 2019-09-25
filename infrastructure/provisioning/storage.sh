#!/bin/bash

# Include vars
source /vagrant/provisioning/vars.sh

echo "[TASK 1] Update NFS Storage /etc/hosts file"
cat >>/etc/hosts<<EOF
172.42.42.100 master.${FQDN} master
172.42.42.101 node1.${FQDN} node1
172.42.42.102 node2.${FQDN} node2
172.42.42.10 loadbalancer.${FQDN} loadbalancer
172.42.42.20 storage.${FQDN} storage
EOF

echo "[TASK 2] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

echo "[TASK 3] Stop and Disable firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld

echo "[TASK 5] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

echo "[TASK 6] Set root password"
echo "kubeadmin" | passwd --stdin root >/dev/null 2>&1

echo "[TASK 7] Configure and start NFS server shares"
systemctl start nfs-server rpcbind
systemctl enable nfs-server rpcbind
mkdir /data
chmod -R 777 /data
chown -R nobody:nobody /data
cat >/etc/exports<<EOF
/data *(rw,sync,no_subtree_check,no_root_squash,insecure)
EOF
exportfs -r
systemctl enable nfs

echo "[TASK 8] Update vagrant user's bashrc file"
echo "export TERM=xterm" >> /etc/bashrc
