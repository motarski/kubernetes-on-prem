# Host used MacOs Mojave v10.14.6
---
# Power Off - On Vagrant gracefully
```
$ vagrant halt         # Shutdowns grafecully
$ vagrant up           # Starts with config checks
# vagrant resume       # Just wake up the machines
```
### To restart from scratch run
```
$ vagrant destroy
```
----
### Dependencies

- Homebrew Package manager
- Docker Desktop for Mac
- Oracle Virtualbox
- HashiCorp Vagrant
- Maven
- Kubernetes Client
- HAProxy

## Install Homebrew Package manager
```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
## Install Docker Desktop for Mac
```
[Installation info ](https://docs.docker.com/docker-for-mac/install/)

Create user on dockerhub later needed for generating kubernetes secret
```

### Login to your Docker registry from Mac host
```
$ docker login docker.io
```
## Install Virtual box, Vagrant and kubectl

```
$ brew cask install virtualbox  # VirtualBox
$ brew cask install vagrant     # Vagrant
```

## Install maven and configure docker registry

```
$ brew install maven
$ vi ~/.m2/settings.xml

# Paste settings block into blank settings.xml file

<settings>
  <servers>
    <server>
      <id>docker.io</id>
      <username>YOUR_DOCKER_USERNAME</username>
      <password>YOUR_DOCKER_PASSWORD</password>
    </server>
  </servers>
</settings>
```

## Install latest version of Kubernetes client
```
$ curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl

```

## Deploy Cluster nodes and LoadBalancer
```
$ vagrant up
```
- Master  Node specs: 2Cpu Core, 1Gb Ram
- Worker1 Node specs: 1Cpu Core, 1Gb Ram
- Worker2 Node specs: 1Cpu Core, 1Gb Ram
- HAProxy Node specs: 1Cpu Core, 512 Mb Ram

### Copy kube config file from master to host to be able to access kubernetes api from host
```
$ vagrant ssh kmaster
$ sudo -i
$ cat /etc/kubernetes/admin.conf
```

### Make directory structure on host and Copy the whole content in the clipboard from vagrant box

```
$ exit
```

### On Mac host type
```
$ mkdir -p ~/.kube
$ vi ~/.kube/config
```

###### Paste the content and save the file. Test access to the cluster and nodes visibility

```
$ kubectl cluster-info
$ kubectl get nodes -o wide
```
### Bash Completeion for kubernetes Client
```
$ brew install bash-completion@2
$ echo 'source <(kubectl completion bash)' >>~/.bashrc
```

#### Edit hosts file on Mac Host to mimic Public IP for the Loadbalancer
```
$ sudo vi /etc/hosts

Add Bellow lines and save / exit

# LoadBalancer for K8s Bare Metal
172.42.42.10 barjaktarov.local
```
## Setup Ingress controller as daemonset
```
$ ./ingress_setup.sh
```

The infrastructure, Loadbalancer and Networking of the cluster is now setup. Configuration used for HAProxy box can also be found in /haproxy directory separately.

## Cluster Logical structure and labels
- Kworker1 labels: disktype=SSD (To be used for database)
- Kworker2 labels: disktype=shared (Slower storage for static objects like web hosting)
