salt-node-docker-cluster
========================

Vagrant + Salt + Node + Docker = Cluster yes.

## What is this?

    This project revolves around a vagrant file (and VirtualBox) for testing out the deployment of a multinode 
    saltstack based cluster.  Node.JS and Docker (with a salt-minion nodejs ubuntu image) 
    are all included and built during the "vagrant up" command. 
   

    The vagrant file deploys a salt master, and three salt minions.  All four virtual machines install docker
    with a salt-minion nodejs docker image.  Whenever this image is used to create containers, it will 
    automatically communicate with the master and exchange keys.   This means all spawned linux containers
    run salt-minion which opens up infinite possibilities for rapid deployment of linux environments

## Requirements

    By default, the ubuntu cloud image for VirtualBox / Vagrant is set to 1 CPU and 512 MB of RAM. 
    Keep this in mind when deploying processes to docker containers.  If more RAM is needed
    update the Vagrantfile and vagrant reload.

## Installation and Running the cluster

    $ git clone https://github.com/PortalGNU/salt-node-docker-cluster.git
    $ cd salt-node-docker-cluster
    $ vagrant up
    $ vagrant ssh [salt, minion-01, minion-02, minion-03] 
    
## Spawning minions to do your bidding

#### Start a salted container

    $ vagrant ssh minion-[01, 02, 03]
    $ sudo docker run -d nodebuntu
    $ exit
    

#### Accept and list our minions

    $ vagrant ssh salt
    $ sudo salt-key -A
    $ sudo salt-key -L 
    

