#/bin/bash -x
get_private_ip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d'/')
echo $private_ip $HOSTNAME >> /etc/hosts
#Intalling k8s
echo "Intalling k8s"
yum install -y sshpass
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl start kubelet
systemctl enable kubelet

#Waiting installation complete of Master
echo "Waiting to K8S completed on Master"
sleep 300

#Join K8S Cluster
echo "Joining K8S Cluster"
sshpass -p "vagrant" scp -o StrictHostKeyChecking=no vagrant@kube-master:/home/vagrant/kubeadm_join_cmd.sh .
chmod +x kubeadm_join_cmd.sh
if [[ $(sh ./kubeadm_join_cmd.sh | grep 'This node has joined the cluster') = "This node has joined the cluste" ]]; then
echo "This node has joined the cluste"
sleep 10
shutdown -r now
fi

#Restart Virtual Machine
#sleep 10
#shutdown -r now
