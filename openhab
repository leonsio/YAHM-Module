#!/bin/bash
#
#
# openhab2 installer
#

description="Openhab2 installer (experimental)"
module_version="0.1"

_module_install()
{

apt-get install debootstrap

lxc-create -n openhab -t debian
yahm-network -n openhab -f attach_bridge
echo lxc.include=config.network >> /var/lib/lxc/openhab/config

lxc-start -n openhab -d

sleep 3


lxc-attach -n openhab -- apt-get install -y wget gpg openjdk-8-jre vim
wget -qO - 'https://bintray.com/user/downloadSubjectPublicKey?username=openhab' | lxc-attach -n openhab -- apt-key add -
lxc-attach -n openhab -- apt-get install -y apt-transport-https
echo 'deb https://dl.bintray.com/openhab/apt-repo2 stable main' | lxc-attach -n openhab  -- tee /etc/apt/sources.list.d/openhab2.list
lxc-attach -n openhab -- apt-get update
lxc-attach -n openhab -- apt-get install -y openhab2

lxc-attach -n openhab -- /bin/systemctl daemon-reload
lxc-attach -n openhab -- /bin/systemctl enable openhab2.service


lxc-attach -n openhab --  sed -i '/shell:sshHost/s/^#//g' /etc/openhab2/services/runtime.cfg

lxc-attach -n openhab -- /bin/systemctl start openhab2.service
}
_module_remove()
{
    lxc-stop -k -n openhab
    rm -rf /var/lib/lxc/openhab
}