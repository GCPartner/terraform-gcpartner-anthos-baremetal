#!/bin/bash
OS='${operating_system}'
IP_ADDRESS='${ip_address}'
NETMASK='${netmask}'

function ubuntu_net_config {
    mkdir -p $HOME/bootstrap/
    cp /etc/network/interfaces $HOME/bootstrap/interfaces.bak
    nic=`ls -la /sys/class/net/ | grep pci | grep -v usb | tail -1 | awk '{print $9}'`
    sudo ifdown $nic
    sed -ie "/$nic/,+4d" /etc/network/interfaces
    sudo printf "\nauto $nic\n" >> /etc/network/interfaces
    sudo printf "iface $nic inet static\n" >> /etc/network/interfaces
    sudo printf "\taddress $IP_ADDRESS\n" >> /etc/network/interfaces
    sudo printf "\tnetmask $NETMASK\n" >> /etc/network/interfaces
    sudo ifup $nic
}

function rhel_net_config {
    nic=`ip a | grep "master bond0" | tail -1 | awk '{print $2}' | awk -F':' '{print $1}'`
    sudo ifdown $nic
    sudo cat <<-EOF > /etc/sysconfig/network-scripts/ifcfg-$nic
        DEVICE=$nic
        ONBOOT=yes
        BOOTPROTO=none
        IPADDR=$IP_ADDRESS
        NETMASK=$NETMASK
EOF
    sudo ifup $nic
}

function unknown_config {
    echo "I don't konw who I am" > $HOME/who_am_i.txt
}

if [ "$${OS:0:6}" = "centos" ] || [ "$${OS:0:4}" = "rhel" ]; then
    rhel_net_config
elif [ "$${OS:0:6}" = "ubuntu" ]; then
    ubuntu_net_config
else
    unknown_config
fi
