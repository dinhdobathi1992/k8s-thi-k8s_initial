#/bin/bash -x
#Intalling k8s
echo "Intalling k8s"
yum install -y sshpass
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl start kubelet
systemctl enable kubelet

#Join K8S Cluster
echo "Joining K8S Cluster"
sshpass -p "vagrant" scp -o StrictHostKeyChecking=no vagrant@kube-master:/home/vagrant/kubeadm_join_cmd.sh .
chmod +x kubeadm_join_cmd.sh
sh ./kubeadm_join_cmd.sh

#Restart Virtual Machine
sleep 10
shutdown -r now