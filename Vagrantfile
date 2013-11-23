# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  
  config.vm.define name = "salt" do |config|
  
    config.vm.box = "ubuntu"
    config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"

    config.vm.hostname = "salt"

    config.vm.network :private_network, ip: "192.168.200.5"

    config.vm.provision :shell, :inline=> "sudo apt-get update"
    config.vm.provision :shell, :inline=> "sudo apt-get -y install language-pack-en linux-image-extra-`uname -r`"
    config.vm.provision :shell, :inline=> "sudo add-apt-repository -y ppa:saltstack/salt"

    config.vm.provision :shell, :inline=> "sudo wget -qO- https://get.docker.io/gpg | apt-key add -"
    config.vm.provision :shell, :inline=> "sudo echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"

    config.vm.provision :shell, :inline=> "sudo apt-get update"
    config.vm.provision :shell, :inline=> "sudo apt-get -y install salt-master lxc-docker git python-pip"
    
    config.vm.provision :shell, :inline=> "sudo mkdir /srv/salt"
    config.vm.provision :shell, :inline=> "sudo mkdir /srv/salt/dev"
    config.vm.provision :shell, :inline=> "sudo mkdir /srv/salt/dev/services"
    config.vm.provision :shell, :inline=> "sudo mkdir /srv/salt/dev/states"
    config.vm.provision :shell, :inline=> "sudo mkdir /srv/salt/prod"
    config.vm.provision :shell, :inline=> "sudo mkdir /srv/salt/prod/services"
    config.vm.provision :shell, :inline=> "sudo mkdir /srv/salt/prod/states"

    config.vm.provision :shell, :inline=> "git clone https://github.com/dotcloud/docker-py.git"
    config.vm.provision :shell, :inline=> "cd docker-py; sudo python setup.py install" 

    config.vm.provision :shell, :inline=> "sudo docker pull ubuntu:latest"
    config.vm.provision :shell, :inline=> "sudo mkdir /etc/docker; sudo mkdir /etc/docker/nodebuntu"
    config.vm.provision :shell, :inline=> "sudo cp /vagrant/install-node.sh /tmp/install-node.sh"
    config.vm.provision :shell, :inline=> "sudo chmod 755 /tmp/install-node.sh"
    config.vm.provision :shell, :inline=> "sudo /tmp/install-node.sh"
    config.vm.provision :shell, :inline=> "sudo cp /vagrant/minion-dockerfile /etc/docker/nodebuntu/Dockerfile"
    config.vm.provision :shell, :inline=> "sudo cp /vagrant/supervisor-salt.conf /etc/docker/nodebuntu"

    config.vm.provision :shell, :inline=> "sudo docker build -t nodebuntu /etc/docker/nodebuntu/"
  end

  (1..3).each do |i|
    config.vm.define vm_name = "minion-%02d" % i do |config|
      config.vm.box = "ubuntu"
      config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"
      
      config.vm.hostname = vm_name

      config.vm.network :private_network, ip: "192.168.200.#{5+i}"

      config.vm.provision :shell, :inline=> "sudo apt-get update"
      config.vm.provision :shell, :inline=> "sudo apt-get -y install language-pack-en linux-image-extra-`uname -r`"
      config.vm.provision :shell, :inline=> "sudo add-apt-repository -y ppa:saltstack/salt"

      config.vm.provision :shell, :inline=> "sudo wget -qO- https://get.docker.io/gpg | apt-key add -"
      config.vm.provision :shell, :inline=> "sudo echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"

      config.vm.provision :shell, :inline=> "sudo apt-get update"
      config.vm.provision :shell, :inline=> "sudo apt-get -y install salt-minion lxc-docker git python-pip"

      config.vm.provision :shell, :inline=> "sudo cp /vagrant/minion /etc/salt/minion"

      config.vm.provision :shell, :inline=> "git clone https://github.com/dotcloud/docker-py.git"
      config.vm.provision :shell, :inline=> "cd docker-py; sudo python setup.py install"

      config.vm.provision :shell, :inline=> "sudo docker pull ubuntu:latest"
      config.vm.provision :shell, :inline=> "sudo mkdir /etc/docker; sudo mkdir /etc/docker/nodebuntu"
      config.vm.provision :shell, :inline=> "sudo cp /vagrant/install-node.sh /tmp/install-node.sh"
      config.vm.provision :shell, :inline=> "sudo chmod 755 /tmp/install-node.sh"
      config.vm.provision :shell, :inline=> "sudo /tmp/install-node.sh"
      config.vm.provision :shell, :inline=> "sudo cp /vagrant/minion-dockerfile /etc/docker/nodebuntu/Dockerfile"
      config.vm.provision :shell, :inline=> "sudo cp /vagrant/supervisor-salt.conf /etc/docker/nodebuntu"

      config.vm.provision :shell, :inline=> "sudo docker build -t nodebuntu /etc/docker/nodebuntu/"

      config.vm.provision :shell, :inline=> "sudo reboot"
    end
  end
end
