from pulumi import ComponentResource, ResourceOptions
from pulumi_gcp import compute

def masteraddr():
    instance_addr = compute.address.Address("master-addr")
    return instance_addr
master_addr = masteraddr()

def node01_addr():
    instance_addr = compute.address.Address("node01-addr")
    return instance_addr
node01addr = node01_addr()

def node02_addr():
    instance_addr = compute.address.Address("node02-addr")
    return instance_addr
node02addr = node02_addr()

def vpc_network():
    network = compute.Network("vpcnetwork", auto_create_subnetworks=True,)
    return network
mynetwork = vpc_network()

compute_firewall = compute.Firewall(
    "firewall",
    network=mynetwork.self_link,
    allows=[
        compute.FirewallAllowArgs(
            protocol="icmp",
        ),
        compute.FirewallAllowArgs(
        protocol="tcp",
        ports=["22", "80", "6443", "443", "8080", "10250"],
    )]
)
