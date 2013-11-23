salt-node-docker-cluster
========================

Vagrant + Salt + Node + Docker = Cluster yes.

## What is this?

    This project revolves around a vagrant file (and VirtualBox) for testing out the 
    deployment of a multinode saltstack based cluster.  Node.JS and Docker 
    (with a salt-minion nodejs ubuntu image) are all included and built 
    during the "vagrant up" command. 
   

    The vagrant file deploys a salt master, and three salt minions.  All four 
    virtual machines install docker with a salt-minion nodejs docker image. 
    Whenever this image is used to create containers, it will automatically 
    communicate with the master and exchange keys.   This means all 
    spawned linux containers run salt-minion which opens up infinite possibilities 
    for rapid deployment of linux environments

## Requirements

    By default, the ubuntu cloud image for VirtualBox / Vagrant is set to 1 CPU and 512 MB of RAM. 
    Keep this in mind when deploying processes to docker containers.  If more RAM is needed
    update the Vagrantfile and vagrant reload.

## Installation and Running the cluster

##### Description

    This cluster runs on a private vbox network on the 192.168.200 subnet.
    Salt server runs on 192.168.200.5 and the minions are 192.168.200.[6,7,8].
    
##### Cmds   
    $ git clone https://github.com/PortalGNU/salt-node-docker-cluster.git
    $ cd salt-node-docker-cluster
    $ vagrant up
    $ vagrant ssh [salt, minion-01, minion-02, minion-03] 
    
## Spawning minions to do your bidding

##### Start a salted node container

    Here we are logging into one of our minion docker servers and spawning
    a minion docker container for a salted node env.  We are assigning
    the docker a useful name (node) so that we can filter it out in our 
    salt-master state configs.
    
    Note:  In order for memory allocation to actually happen, there must
    be swap space allocated on the minion server.  

##### Cmds

    $ vagrant ssh minion-[01, 02, 03]
    $ sudo docker run -d -name node -h node -m 279969792 -v /vagrant:/vagrant -p 3000 nodebuntu
    $ exit
    

#### Accept and list our minions

    $ vagrant ssh salt
    $ sudo salt-key -A
    $ sudo salt-key -L 
    
## Make demands to our node minion

#### Description

    For a quick example of states, we'll double check nodejs (and deps)
    installed into the container during our docker image build.
    
    While still ssh'ed into salt create the following files described below.
    Then, run the commands in the Cmds section.
    
##### /srv/salt/top.sls

```python
base:
  '*':
    - nodejs.deps
    - python.deps
```

##### /srv/salt/python/deps.sls

```python
python:
  pkg:
    - installed
```

##### /srv/salt/nodejs/deps.sls

```python
coffee:
  npm.installed:
    - name: coffee-script

bower:
  npm.installed

express:
  npm.installed
```

##### Cmds

    $  sudo salt 'node' state.highstate
    

    node:
    ----------
        State: - npm
        Name:      coffee-script
        Function:  installed
            Result:    True
            Comment:   Package coffee-script satisfied by coffee-script@1.6.3
            Changes:   
    ----------
        State: - npm
        Name:      bower
        Function:  installed
            Result:    True
            Comment:   Package bower satisfied by bower@1.2.7
            Changes:   
    ----------
        State: - npm
        Name:      express
        Function:  installed
            Result:    True
            Comment:   Package express satisfied by express@3.4.4
            Changes:   
    ----------
        State: - pkg
        Name:      python
        Function:  installed
            Result:    True
            Comment:   Package python is already installed
            Changes:   
    
    Summary
    ------------
    Succeeded: 4
    Failed:    0
    ------------
    Total:     4
