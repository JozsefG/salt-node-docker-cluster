salt-node-docker-cluster
========================

Vagrant + Salt + Node + Docker = Cluster yes.

## What is this?
    This project revolves around a vagrant file (and VirtualBox) for testing out the deployment of a multinode 
    saltstack based cluster.  Node.JS and Docker (with a nodejs ubuntu image) are all included and built during
    the "vagrant up" command. 
   
    The vagrant file deploys a salt master, and three salt minions.  All four virtual machines install docker
    with a salt-minion nodejs docker image.  Whenever this image is used to create containers, it will 
    automatically communicate with the master and exchange keys.   This means all spawned linux containers
    run salt-minion which opens up infinite possibilities for rapid deployment of linux environments
## 
