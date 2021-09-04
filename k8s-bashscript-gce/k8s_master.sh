#/bin/bash -x
#Init Network setting
echo "Initialization Master Machine"
get_private_ip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d'/')
get_public_ip=$(curl icanhazip.com)
echo $get_private_ip kube-master >> /etc/hosts
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
systemctl restart sshd

#Set password is "vagrant" for vagrant user. Syntax: echo username:password | chpasswd
echo vagrant:vagrant | chpasswd

#Installing k8s
echo "Installing K8S packages"
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl start kubelet
systemctl enable kubelet
#Config k8s with assign ip address to k8s api server
kubeadm init --apiserver-advertise-address $get_private_ip --pod-network-cidr 172.16.0.0/16 --apiserver-cert-extra-sans=$get_private_ip,$get_public_ip
sleep 5

#Create admin config
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Install Flannel CNI (container network interface) plugin for Kubernetes
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
sleep 5

#Extract Join cluster information
join_cmd=$(kubeadm token create --print-join-command)
echo $join_cmd >> /home/vagrant/kubeadm_join_cmd.sh
export_conf=$(kubectl config view --minify --raw)
echo $export_conf >> /home/vagrant/kubeconf

#Restart Virtual Machine
sleep 10
shutdown -r now