#!/bin/bash -x
#Varible System
docker_daemon=/etc/docker/daemon.json
network=192.168.230 #This is host network of vmware workstation (or virtualbox). Please change it to match your virtualization environment
# OS Setting
echo "nameserver 8.8.8.8" > /etc/resolv.conf
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
systemctl stop firewalld
systemctl disable firewalld
yum -y install net-tools wget bind-utils epel-release
sed -i 's/enforcing/disabled/g' /etc/selinux/config
setenforce 0

#Iptables Setting
modprobe br_netfilter
cat >> /etc/sysctl.d/k8s.conf <<'EOF'
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

#Turn off SWAP to increse performance
swapoff -a

#set hostname /etc/hosts
#length=9 mean number of node workers
echo $network.10 kube-master > /etc/hosts
for i in {1..9}
do 
  echo $network.1$i kube-worker-$i >> /etc/hosts
done

#Install Docker-CE
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
yum install -y docker-ce
systemctl start docker
systemctl enable docker

#Set docker daemon.json
if [[ ! -e $docker_daemon ]]; then
    touch $docker_daemon
fi
cat >> $docker_daemon <<'EOF'
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
systemctl restart docker

#Add K8S repository
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
yum makecache

#Installing K8S Cluster
if [ "$HOSTNAME" = kube-master ]; then
      if [ ! -d /vagrant ]; then
      mkdir /vagrant && cd /vagrant
      wget https://gitlab.com/devops1164/deploy-k8s/-/raw/main/k8s-bashscript-autoinstall/k8s_master.sh?inline=false -O /vagrant/k8s_master.sh
      sh k8s_master.sh
      fi
else
      if [ ! -d /vagrant ]; then
      mkdir /vagrant && cd /vagrant
      wget https://gitlab.com/devops1164/deploy-k8s/-/raw/main/k8s-bashscript-autoinstall/k8s_node.sh?inline=false -O /vagrant/k8s_node.sh
      sh k8s_node.sh
      fi
fi
