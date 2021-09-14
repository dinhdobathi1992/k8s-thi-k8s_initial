1) Download k8s_init.sh (on both of Master and Worker):
- wget https://gitlab.com/devops1164/deploy-k8s/-/raw/main/k8s-bashscript-gce/k8s_init.sh?inline=false -O k8s_init.sh

2) Change your Master ipaddress and Master hostname:
- master_ip=10.148.0.2 #Private IP address of K8S Master instance. Chang it to match your environment
- master_hostname=kube-master #Hostname of K8S Master instance.Chang it to match your environmen

3) Running script (both of Master and Worker):
- sh ./k8s_init.sh
