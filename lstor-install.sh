#!/bin/sh

cd "$(dirname $0)"

echo -n "Install target: "
read TARGET;

if [[ -z $TARGET ]]; then
    echo "No install target specified!"
    exit -1;
fi

echo -n "Install user: "
read USER;

echo -n "User password (leave blank if none): "
read -s PASSWORD;
echo ""

DISTRO=$(ssh -i install/ssh $USER@$TARGET "source /etc/os-release; echo \$ID")

if [[ ! -e "playbooks/lstor-deploy-$DISTRO.yaml" ]]; then
    echo "Unsupported distro: $DISTRO";
    exit -1;
fi

echo "Installing prerequesits [1/1]..."
ansible-playbook --private-key install/ssh "playbooks/lstor-deploy-$DISTRO.yaml" --extra-vars "ansible_user=$USER lstor_target=$TARGET ansible_become_password=$PASSWORD" -i "$TARGET,"

echo "Installing LStor [1/1]..."
ansible-playbook --private-key install/ssh "playbooks/lstor-install-scripts.yaml" --extra-vars "ansible_user=$USER lstor_target=$TARGET ansible_become_password=$PASSWORD" -i "$TARGET,"