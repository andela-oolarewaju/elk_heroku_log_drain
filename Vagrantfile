# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.provider "virtualbox" do |vb|
     vb.memory = "1024"
  end
  config.vm.network "forwarded_port", guest: 5601, host: 5601
  config.vm.network "forwarded_port", guest: 9200, host: 9200
  config.vm.network "forwarded_port", guest: 1514, host: 1514
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.provision.yml"
    ansible.inventory_path = "inventory.ini"
    ansible.sudo = true
    ansible.verbose = "v"
  end
  config.vm.define "elkserver"
  config.vm.hostname = "elkserver"
end
