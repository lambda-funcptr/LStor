#!/bin/sh


echo -n "Install target: "
read TARGET;

if [[ -z $TARGET ]]; then
    echo "No install target specified!"
    exit -1;
fi

echo -n "Install user: "
read USER;

echo -n "User password for sudo escelation (leave blank if none exists): "
read -s PASSWORD;
echo ""

DISTRO=$(ssh -i install/ssh $USER@$TARGET "source /etc/os-release; echo \$ID")

if [[ ! -e "playbooks/lstor-deploy-$DISTRO.yaml" ]]; then
    echo "Unsupported distro: $DISTRO";
    exit -1;
fi

ansible-playbook --private-key install/ssh "playbooks/lstor-deploy-$DISTRO.yaml" --extra-vars "ansible_user=$USER lstor_target=$TARGET ansible_become_password=$PASSWORD" -i "$TARGET,"