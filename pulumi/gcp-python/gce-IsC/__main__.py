import pulumi
import pulumi_gcp as gcp

default_instance = gcp.compute.Instance("isc-develop",
    machine_type="e2-standard-2",
    zone="asia-southeast1-b",
    boot_disk=gcp.compute.InstanceBootDiskArgs(
        initialize_params=gcp.compute.InstanceBootDiskInitializeParamsArgs(
            image="rocky-linux-cloud/rocky-linux-8-v20210817",
        ),
    ),
    network_interfaces=[gcp.compute.InstanceNetworkInterfaceArgs(
        network_ip="10.148.0.234",
        network="default",
        access_configs=[gcp.compute.InstanceNetworkInterfaceAccessConfigArgs()],
    )],
)