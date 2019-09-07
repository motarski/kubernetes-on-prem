#!/bin/bash

# Update hosts file
echo "[TASK 1] Update HAProxy /etc/hosts file"
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

# Install haproxy
echo "[TASK 7] Install, Configure and start HAProxy service"
yum install haproxy -y

# Modify HAProxy configuration
cat >/etc/haproxy/haproxy.cfg<<EOF
global
    log         127.0.0.1 local2

    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon

    stats socket /var/lib/haproxy/stats

defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 3000

# Loadbalacing between Kubernetes nodes

frontend http_front
  bind *:80
  stats uri /haproxy?stats
  default_backend http_back

backend http_back
  balance roundrobin
  server kube kworker1:80
  server kube kworker2:80
EOF
systemctl enable haproxy.service
systemctl start haproxy.service

# Update vagrant user's bashrc file
echo "[TASK 8] Update vagrant user's bashrc file"
echo "export TERM=xterm" >> /etc/bashrc
