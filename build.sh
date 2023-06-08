#!/bin/bash
terraform apply -auto-approve
terraform output -json | yq e -P '.ansible_inventory.value' - | yq e '.. style="double"' - > rmme
echo -- waiting 20 sec for all srvs to get rdy --
sleep 20
for i in $(yq e ".all.hosts.*.ansible_host" rmme); 
  do 
    ssh-keyscan -H  $i >> ~/.ssh/known_hosts; 
  done

# ansible-playbook -i rmme ansible/ceph.playbook.yml
