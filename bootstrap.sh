#!/bin/bash
# Bootstrap machine

ensure_netplan_apply() {
    # First node up assign dhcp IP for eth1, not base on netplan yml
    sleep 5
    sudo netplan apply
}

step=1
step() {
    echo "Step $step $1"
    step=$((step+1))
}

resolve_dns() {
    step "===== Create symlink to /run/systemd/resolve/resolv.conf ====="
    sudo rm /etc/resolv.conf
    sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
}



install_nachos() {
    step "===== Installing nachos ====="
    sudo apt install make -y
    sudo apt-get install default-jdk -y
    sudo curl http://www.cas.mcmaster.ca/~rzheng/course/CAS3SH3w14/nachos-java.tar.gz --output nachos-java.tar.gz
    sudo tar -xvzf nachos-java.tar.gz
tee -a /home/vagrant/.bashrc << END
JAVA_HOME=/usr/bin/java
export JAVA_HOME
PATH=$PATH:/usr/bin/java:/home/vagrant/nachos/bin
export PATH
END
}

install_openssh() {
    step "===== Installing openssh ====="
    sudo apt update
    sudo apt -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    sudo apt install -y openssh-server
    sudo systemctl enable ssh
}

setup_root_login() {
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo systemctl restart ssh
    sudo echo "root:rootroot" | chpasswd
}

setup_welcome_msg() {
    sudo apt -y install cowsay
    version=$(cat /etc/os-release |grep VERSION= | cut -d'=' -f2 | sed 's/"//g')
    sudo echo -e "\necho \"Welcome to Vagrant Ubuntu Server ${version}\" | cowsay\n" >> /home/vagrant/.bashrc
    sudo ln -s /usr/games/cowsay /usr/local/bin/cowsay
}

main() {
    ensure_netplan_apply
    resolve_dns
    install_openssh
    setup_root_login
    setup_welcome_msg
    install_nachos
}

main