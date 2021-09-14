import pulumi
from pulumi import ResourceOptions
from pulumi_gcp import compute
from pulumi_gcp.compute.instance import Instance
from network_instance import master_addr, node01addr, node02addr, compute_firewall, mynetwork

#Init OS instance
#script = """#!/bin/bash -x
#sudo -i
#curl -sfL https://gitlab.com/devops1164/deploy-k8s/-/raw/main/k8s-bashscript-gce/k8s_init.sh?inline=false | sh -
#"""

#Create master machine
master_instance = compute.Instance( "kube-master",
    name="kube-master",
    machine_type="e2-standard-2",
    boot_disk=compute.InstanceBootDiskArgs(
        initialize_params=compute.InstanceBootDiskInitializeParamsArgs(
            image="rocky-linux-cloud/rocky-linux-8-v20210817"
        )
    ),
    network_interfaces=[compute.InstanceNetworkInterfaceArgs(
            network=mynetwork.id,
            network_ip="10.148.0.2",
            access_configs=[compute.InstanceNetworkInterfaceAccessConfigArgs(
                nat_ip=master_addr.address,
            )],
    )],
    service_account=compute.InstanceServiceAccountArgs(
        scopes=["https://www.googleapis.com/auth/cloud-platform"],
    ),
    opts=ResourceOptions(depends_on=[compute_firewall]),
    #metadata_startup_script=script,
)
pulumi.export("master_name", master_instance.name)
pulumi.export("master_network_instance", master_addr.address)

#Create node01 machine
node01_instance = compute.Instance(
        "kube-node-1",
        name="kube-node-1",
        machine_type="e2-standard-2",
        boot_disk=compute.InstanceBootDiskArgs(
            initialize_params=compute.InstanceBootDiskInitializeParamsArgs(
                image="rocky-linux-cloud/rocky-linux-8-v20210817"
            )
        ),
        network_interfaces=[compute.InstanceNetworkInterfaceArgs(
            network=mynetwork.id,
            network_ip="10.148.0.3",
            access_configs=[compute.InstanceNetworkInterfaceAccessConfigArgs(
                nat_ip=node01addr.address,
            )],
        )],
        service_account=compute.InstanceServiceAccountArgs(
        scopes=["https://www.googleapis.com/auth/cloud-platform"],
    ),
    opts=ResourceOptions(depends_on=[compute_firewall]),
    #metadata_startup_script=script,
)
pulumi.export("node01_name", node01_instance.name)
pulumi.export("node01_network_instance", node01addr.address)
#Create node02 machine
node02_instance = compute.Instance(
        "kube-node-2",
        name="kube-node-2",
        machine_type="e2-standard-2",
        boot_disk=compute.InstanceBootDiskArgs(
            initialize_params=compute.InstanceBootDiskInitializeParamsArgs(
                image="rocky-linux-cloud/rocky-linux-8-v20210817"
            )
        ),
        network_interfaces=[compute.InstanceNetworkInterfaceArgs(
            network=mynetwork.id,
            network_ip="10.148.0.4",
            access_configs=[compute.InstanceNetworkInterfaceAccessConfigArgs(
                nat_ip=node02addr.address,
            )],
        )],
        service_account=compute.InstanceServiceAccountArgs(
        scopes=["https://www.googleapis.com/auth/cloud-platform"],
    ),
    opts=ResourceOptions(depends_on=[compute_firewall]),
    #metadata_startup_script=script,
)
pulumi.export("node02_name", node02_instance.name)
pulumi.export("node02_network_instance", node02addr.address)