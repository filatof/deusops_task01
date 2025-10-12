
ansible-playbook -i inventory.yml playbooks/create_cluster.yml -e "env=stage" --ask-vault-pass

ansible-playbook -i inventory.yml playbooks/create_cluster.yml -e "env=prod" --ask-vault-pass