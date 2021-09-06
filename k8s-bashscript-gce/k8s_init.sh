#!/bin/bash -x
#Varible System. Edit here to correct with your instance
docker_daemon=/etc/docker/daemon.json
master_ip=10.148.0.2 #Private IP address of K8S Master instance
master_hostname=kube-master #Hostname of K8S Master instance

#This is host network of vmware workstation on my machine. Please check to your machine correct more.
#network=192.168.230

#Iptables Setting
modprobe br_netfilter
cat >> /etc/sysctl.d/k8s.conf <<'EOF'
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

#Turn off SWAP to increse performance
swapoff -a

#set hostname /etc/hosts. Only use to Cloud Instance like (AWS, GCE...)
echo $master_ip $master_hostname >> /etc/hosts

#Install Docker-CE
yum install -y yum-utils epel-release
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
yum upgrade -y

#Installing K8S Cluster
if [ "$HOSTNAME" = kube-master ]; then
  chmod 755 /vagrant/k8s_master.sh
  sh /vagrant/k8s_master.sh
else
  chmod 755 /vagrant/k8s_node.sh
  sh /vagrant/k8s_node.sh
fi
