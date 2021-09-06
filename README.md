<!-- A GCP service account key:
- Create a service account key to enable Terraform to access your GCP account. When creating the key, use the following settings:
    + Select the project you created in the previous step.
    + Click "Create Service Account".
    + Give it any name you like and click "Create".
    + For the Role, choose "Project -> Editor", then click "Continue".
    + Skip granting additional users access, and click "Done".
    + After you create your service account, download your service account key.

    + Select your service account from the list.
    + Select the "Keys" tab.
    + In the drop down menu, select "Create new key".
    + Leave the "Key Type" as JSON.
Click "Create" to create the key and save the key file to your system.
Copy file service account to working folder
 -->
# Prepare information and update in variable file
- gce_ssh_user
- gce_project_id
- gce_image
- machine_type
- zone
- region
# check and update path variable gce_ssh_pub_key_file and gce_ssh_pvt_key_file
# Rewrite terraform configuration files to a cnonical format and style
- terraform fmt
# validates the configuration files in a directory
- terraform validate
# create an execution plan
- terraform plan
# executes the actions proposed in a terraform plan
- terraform apply
# update external ip in ansibler variable ~/ansible/inventory/hosts and ip external master, user ssh at ~/ansible/inventory/group_vars/all
- cd /ansible
- ansible-playbook -i inventory/hosts master-playbook.yml -v
- ansible-playbook -i inventory/hosts node-playbook.yml -v
# ansible will auto fetch file kube config in /ansible/config change server: https://external_IP:6443