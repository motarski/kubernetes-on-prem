# Provision Kubernetes cluster and Load Balancer for educational presentation

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  # NFS Server as an actor of 'Cloud' storage
  config.vm.define "nfs" do |nfs|
    nfs.vm.box = "centos/7"
    nfs.vm.hostname = "storage.edu.local"
    nfs.vm.network "private_network", ip: "172.42.42.20"
    nfs.vm.provider "virtualbox" do |v|
      v.name = "storage"
      v.memory = 256
      v.cpus = 1
    end
    nfs.vm.provision "shell", path: "storage.sh"
  end

  # HAProxy as a Load Balancer for Bare Metal K8s Cluster
  config.vm.define "haproxy" do |haproxy|
    haproxy.vm.box = "centos/7"
    haproxy.vm.hostname = "haproxy.edu.local"
    haproxy.vm.network "private_network", ip: "172.42.42.10"
    haproxy.vm.provider "virtualbox" do |v|
      v.name = "haproxy"
      v.memory = 256
      v.cpus = 1
    end
    haproxy.vm.provision "shell", path: "haproxy.sh"
  end

  # Kubernetes Master Server
  config.vm.define "kmaster" do |kmaster|
    kmaster.vm.box = "centos/7"
    kmaster.vm.hostname = "kmaster.edu.local"
    kmaster.vm.network "private_network", ip: "172.42.42.100"
    kmaster.vm.provider "virtualbox" do |v|
      v.name = "kmaster"
      v.memory = 1024
      v.cpus = 2
    end
    kmaster.vm.provision "shell", path: "bootstrap.sh"
    kmaster.vm.provision "shell", path: "bootstrap_kmaster.sh"
  end

  NodeCount = 2

  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    config.vm.define "kworker#{i}" do |workernode|
      workernode.vm.box = "centos/7"
      workernode.vm.hostname = "kworker#{i}.edu.local"
      workernode.vm.network "private_network", ip: "172.42.42.10#{i}"
      workernode.vm.provider "virtualbox" do |v|
        v.name = "kworker#{i}"
        v.memory = 1024
        v.cpus = 1
      end
      workernode.vm.provision "shell", path: "bootstrap.sh"
      workernode.vm.provision "shell", path: "bootstrap_kworker.sh"
    end
  end

end
