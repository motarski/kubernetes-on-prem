#!/bin/bash

# Update hosts file
echo "[TASK 1] Update NFS Storage /etc/hosts file"
cat >>/etc/hosts<<EOF
172.42.42.100 kmaster.edu.local kmaster
172.42.42.101 kworker1.edu.local kworker1
172.42.42.102 kworker2.edu.local kworker2
172.42.42.10 harpoxy.edu.local haproxy
172.42.42.20 storage.edu.local storage
EOF

# Disable SELinux
echo "[TASK 2] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

# Stop and disable firewalld
echo "[TASK 3] Stop and Disable firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld

# Enable ssh password authentication
echo "[TASK 5] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
echo "[TASK 6] Set root password"
echo "kubeadmin" | passwd --stdin root >/dev/null 2>&1

# Install and configure NFS Storage shares
echo "[TASK 7] Install, Configure and start NFS server shares"
yum install -y nfs-utils
systemctl start nfs-server rpcbind
systemctl enable nfs-server rpcbind
mkdir /www-data
mkdir /db-data
chmod 777 /www-data
chmod 777 /db-data
chown -R nobody:nobody /www-data /db-data
cat >/etc/exports<<EOF
/db-data *(rw,sync,no_subtree_check,no_root_squash,insecure)
/www-data *(rw,sync,no_subtree_check,no_root_squash,insecure)
EOF
exportfs -r
systemctl enable nfs

# Update vagrant user's bashrc file
echo "[TASK 8] Update vagrant user's bashrc file"
echo "export TERM=xterm" >> /etc/bashrc
