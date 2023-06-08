!#/bin/bash
for i in $(yq e ".all.hosts.*.ansible_host" rmme); 
  do ssh-keygen -R $i; 
  done
terraform apply -destroy -auto-approve
