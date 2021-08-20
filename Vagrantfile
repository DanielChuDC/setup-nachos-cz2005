# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.provider :libvirt do |libvirt|
        libvirt.driver = "kvm"
    end
    config.vm.box = "generic/ubuntu2004"
    config.vm.box_version = "3.3.4"
    config.vm.provision:shell, inline: <<-SHELL
        echo "root:rootroot" | sudo chpasswd
        sudo timedatectl set-timezone Asia/Singapore
    SHELL

    config.vm.define "ubuntu20.04" do |ubuntu|
        ubuntu.vm.hostname = "ubuntu20.04"
    end

    config.vm.provision:shell, path: "bootstrap.sh"
end