#!/bin/sh

if [[ -z $1 || -z $2 ]]; then
    echo "No install target specified!"
    exit -1;
fi

DISTRO=$(ssh -i install/ssh $1@$2 "source /etc/os-release; echo \$ID")

ansible-playbook --private-key install/ssh "playbooks/lstor-deploy-$DISTRO.yaml" --extra-vars "ansible_user=$1 target=$2" -i "$2,"