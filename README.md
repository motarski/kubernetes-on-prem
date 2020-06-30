#  The most complete solution for provisioning on-premise kubernetes cluster
_Solution version release: v2.0_
## What's new in this version
- Scale up cluster size
- Kubernetes version is now `v1.18.4`
- Ansible is the tool used for provisioning
- Helm 3 installed together with the requirements
- Everything is automated. Installing requirements is now 'one-step script'
- Platform auto detection upon installing requirements (Linux or Mac)
- `Ubuntu` is now used for nodes and HAProxy. `CentOS` for the NFS
- WordPress database is now deployed as stateful set

## Infrastructure as code - IaC

- Immutable infrastructure provisioned with Vagrant
- Configuration management with Ansible
- Installing requirements with Bash scripts

## Components included
- Kubernetes control-plane
- Two worker nodes
- NFS server
- HAProxy

## Functionalitiies includeed
- API gateway
- Custom storage class for volume provisioning
- Loadbalancer

## Hosts supported
The solution is tested end-to-end on both hosts

- **MacOs Catalina `10.15.5`** with Oracle VirtualBox `6.1`, Vagrant `2.2.9`
- **Ubuntu Linux `18.04 LTS`** with Oracle VirtualBox `6.1`, Vagrant `2.2.9`

## Cavaets
- Current cluster dimensioning is recommended for hosts that have 16Gb RAM or more. If your host has less than that I recommended to provision the cluster with one node less. This can be done by setting the NodeCount value in Vagrantfile to one

```bash

  NodeCount = 1

  # Kubernetes nodes
  (1..NodeCount).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.box = "ubuntu/bionic64"
  ...
```
- `Vagrant`, `Ansible`, `VirtualBox`. Too many players, too many technologies at one place. Convenient but maybe not super stable all of the time. If you experience any errors during provisioning you can always resume from where you stopped either by running only ansible provisioning on certain node or the infrastructure provisioning as well

```bash
$ vagrant provision master # To re-provision if something happened during ansible provisioning
$ vagrant up node1 node2 # To continue after master has been re-provisioned manually
```
- If you discovered new ones email me: ivan.thegreat@gmail.com

---

# Provision your own on-premise kubernetes cluster

### Step 1: Install required dependencies
On linux you will be asked to run the script with sudo. When running on Mac you will be asked for sudo pass during script execution
```bash
$ cd infrastructure
$ ./install_requirements
```

### Step 2: Provision and configure kubernetes cluster
```bash
$ vagrant up
```

### Step 3: Configure core cluster functionalities
```bash
$ ./infra_setup
```

# Cluster specification

| VM Role   |      CPU     |  RAM | IP Address
|--------|:-------------:|:------:|:----:|
| Master |  2 | 2 Gb | 172.42.42.100
| Node 1 |  1   | 1.5 Gb | 172.42.42.101
| Node 2 | 1 |    1.5 Gb | 172.42.42.102
| Loadbalancer | 1 | 512 Mb | 172.42.42.10
|NFS storage | 1 | 512 Mb| 172.42.42.20
| **TOTAL** | **6 CPU**| **6 GB**



---
# Tips after provisioning the cluster

### How can I check if the cluster is working?

Deploy the demo WordPress site. Check the documentation under website directory

### Shut down VM's when you don't want to use the cluster

When you are done with using the cluster shut it down to release host resources. Always Power On/Of vagrant provisioned VM's gracefully
```bash
$ cd infrastructure
$ vagrant halt         # Shutdowns grafecully
$ vagrant up           # Starts with config checks
```

### Provisioning of haproxy failed. What should I do?
Restart reprovisioning of haroxy
```bash
$ vagrant provision haproxy
```

### Provision only selected components
Not always you have to provision the entire solution. You can select which components to provision
```bash
$ vagrant up node3 # Add third node to the cluster
$ vagrant up nfs # Provision only the NFS server
```

### Can I scale up the number of worker nodes after provisioning?
Yes. You can scale up or down. Change the `NodeCount` value in Vagrantfile to match the new cluster size `ex: NodeCount = 5` and bring the new nodes up
```bash
$ vagrant up node3 node4 node5
```
### Delete the entire cluster including the VM's
Sometimes you maybe want to start over clean. Immutable infrastructure approach allows you to do that in a matter of minutes
```bash
$ vagrant destroy master node1 node2 nfs haproxy -f
```
