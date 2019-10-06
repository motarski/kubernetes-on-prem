# Kubernetes On-Prem cluster with Kong API Gateway
Components included:
- Kubernetes `v1.15.4`
- Kong API Gateway
- Dynamic NFS Persistent volume provisioner
- HAProxy LoadBalancer
- Metrics Server
- Tiller


### Hosts supported

- **MacOs Mojave `10.14.6`** with Oracle VirtualBox `6.0.10`, Vagrant `2.2.5`
- **Ubuntu Linux `18.04.3 LTS`** with Oracle VirtualBox `6.0.12`, Vagrant `2.2.5`

### Prerequisites (Mac & Linux)

- Homebrew Package manager (Mac only)
- Oracle VirtualBox
- Vagrant
- Kubernetes Client (kubectl)
- Helm client

### Homebrew Package manager (Mac)
```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Virtual box and Vagrant (Mac)

```
$ brew cask install virtualbox  # VirtualBox
$ brew cask install vagrant     # Vagrant
```
### Virtual box and Vagrant (Ubuntu Linux 18.04.3 LTS)
```
$ wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
$ wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
$ sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian bionic contrib"
$ sudo apt update
$ sudo apt install virtualbox-6.0
$ wget https://releases.hashicorp.com/vagrant/2.2.5/vagrant_2.2.5_x86_64.deb
$ sudo dpkg -i vagrant_2.2.5_x86_64.deb
```

### Kubernetes client latest version (Mac)
```
$ curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl
```
### Kubernetes client latest version (Ubuntu Linux 18.04.3 LTS)
```
$ curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
$ chmox +x kubectl
$ sudo mv kubectl /usr/bin/
```

### Bash completion for kubectl (Mac)
```
$ brew install bash-completion@2
$ echo 'source <(kubectl completion bash)' >>~/.bashrc
```
### Bash completion for kubeclt (Ubuntu Linux 18.04.3 LTS)
```
$ sudo apt-get install bash-completion
$ echo 'source <(kubectl completion bash)' >>~/.bashrc
```

### Helm (Mac)

```
brew install kubernetes-helm
```
### Helm (Ubuntu Linux 18.04.3 LTS)
```
$ wget https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz
$ tar --extract --file=helm-v2.14.3-linux-amd64.tar.gz linux-amd64/helm
$ sudo mv linux-amd64/helm /usr/bin/helm && rm -rf linux-amd64/helm
```

## Provision the infrastructure
```
$ cd infrastructure
$ vagrant up
```
Resources that will be provisioned
- Master VM specs: 2Cpu, 2Gb Ram, IP: 172.42.42.100
- Node1 VM specs: 1Cpu, 1.5Gb Ram, IP: 172.42.42.101
- Node2 VM specs: 1Cpu, 1.5Gb Ram, IP: 172.42.42.102
- Loadbalancer HAProxy VM specs: 1Cpu, 256 Mb Ram, IP: 172.42.42.10
- Storage NFS server VM specs: 1Cpu, 256 Mb Ram, IP: 172.42.42.20

### Configure DNS and the rest of the infrastructure
Make sure you are in the infrastructure directory. Script `dns_setup` has to be run in privileged mode (sudo) due to changes it wants to make on the host

```
$ ./infra_setup
$ sudo ./dns_setup
```

The core infrastructure components are now setup. To test cluster functionality deploy the wordpress with mysql application website using persistent volumes and ingress. More info at the website directory documentation

### Dynamic NFS Provisioner
Persistent volumes don't need to be created before hand. Persistent volume claims will automatically create volumes. Retention policy is set currenttly to Delete, meaning upon deletion of the claims volumes related with them will also be automatically deleted. You can setup different retention policy in the Storage Class for NFS provisioning

---
# Q & A Section

### How do I use the cluster for deploying the application?

Check the documentation under website directory

### How do I shut down virtualbox VM's when I don't want to use the cluster?

Always Power On/Off vagrant machines gracefully
```
$ vagrant halt         # Shutdowns grafecully
$ vagrant up           # Starts with config checks
```

### How can I change the version of the kubernetes cluster?

By changing the value of `KUBERNETES_VERSION` variable in `vars.sh` located at `infrastructure/provisioning`. You can track the kubernetes releases https://github.com/kubernetes/kubernetes/releases please note that changing version may introduce breaking changes that has not fully been tested with this code. Code in this repo has been tested and marked as `stable` up to version `v1.15.4`. Using any higher version than that one is considered `Preview`

### How can I change the default DNS record barjaktarov.local?

By changing the value of `FQDN` variable in `vars.sh` located at `infrastructure/provisioning`.

### What is next in queue for development?

Plan is to move completely away from using declarative yaml to Helm charts deployment    
