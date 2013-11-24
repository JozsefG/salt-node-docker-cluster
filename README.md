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
    
## Verify docker server minions have pre-built salted node image "nodebuntu"

#### Description
    
    With the dockerio state, we will verify that the docker image "nodebuntu" is 
    built and ready to use.
    
#### Cmds

    $ sudo salt 'minion-01' state.highstate
    
#### Output
    minion-01:
    ----------
        State: - docker
        Name:      nodebuntu
        Function:  built
            Result:    True
            Comment:   Image already built: nodebuntu, id: 27ca229ad947061aeda63f2f25622f3af9dd63c2d0e70ac43e6c73a61e2d8cac
            Changes:   
    
    Summary
    ------------
    Succeeded: 5
    Failed:    0
    ------------
    Total:     5
    
    
## Spawning minions to do your bidding

##### Start a salted node container

    Here we are logging into one of our minion docker servers and spawning
    a minion docker container for a salted node env.  We are assigning
    the docker a useful name (node) so that we can filter it out in our 
    salt-master state configs.
    
    Note:  In order for memory allocation to actually happen, there must
    be swap space allocated on the minion server.  
    
    Also Note:  This should really by run on salt-master with the docker
    module.  Right now this is the only time we will go on a minion itself.

##### Cmds

    $ vagrant ssh minion-01
    $ sudo docker run -d -name node -h node -m 279969792 -v /vagrant:/vagrant -p 3000 nodebuntu
    $ exit
    

#### Accept and list our minions

    $ vagrant ssh salt
    $ sudo salt-key -A
    $ sudo salt-key -L 
    
## Verify our node container minion is online

##### Description
    We will use the active module and state scripts for dockerio in this project.
    Included in the srv folder are _modules and _states subfolders with the dockerio
    py files.
    
##### Cmds
    
    $ vagrant ssh salt
    $ sudo salt 'minion-01' docker.get_containers all=false

 
##### Output:
    minion-01:
        ----------
        comment:
            All containers in out
        id:
            None
        out:
            ----------
            - Command:
                /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
            - Created:
                1385235040
            - Id:
                f99a4e4730d6ef9d00f5369aa11af386b8fc7d538faea196953815684ca1a551
            - Image:
                nodebuntu:latest
            - Names:
                - /node
            - Ports:
                ----------
                - IP:
                    0.0.0.0
                - PrivatePort:
                    3000
                - PublicPort:
                    49155
                - Type:
                    tcp
            - SizeRootFs:
                0
            - SizeRw:
                0
            - Status:
                Up 3 hours
        status:
            True
    
## Make demands to our node container minion

#### Description

    For a quick example of states, we'll double check nodejs (and deps)
    installed into the container during our docker image build, and run
    a node httpd app on port 3000.
    
    This project includes a srv folder that is copied to /srv on the master.
    Please see these files for config details.
    
    Also note, /srv/salt/node/src is synced by salt master 
    for this demonstration.
    
    We are essentially telling salt-master to inject the 'node' minion
    running in a docker container on minion-01 with a nodejs httpd 
    based webapp that runs on port 3000.  Once the highstate is complete,
    the container must be restarted for supervisord to pick up the new config.
    
    Finally, we can verify the restart succeeded by viewing the container's logs.

##### Cmds

    $  sudo salt 'node' state.highstate
    
##### Output
    node:
    ----------
        State: - pkg
        Name:      supervisor
        Function:  installed
            Result:    True
            Comment:   Package supervisor is already installed
            Changes:   
    ----------
        State: - service
        Name:      supervisor
        Function:  running
            Result:    True
            Comment:   The service supervisor is already running
            Changes:   
    ----------
        State: - file
        Name:      /opt/src
        Function:  recurse
            Result:    True
            Comment:   The directory /opt/src is in the correct state
            Changes:   
    ----------
        State: - file
        Name:      /etc/supervisor/conf.d/node-web-skel.conf
        Function:  managed
            Result:    True
            Comment:   File /etc/supervisor/conf.d/node-web-skel.conf is in the correct state
            Changes:   
    ----------
        State: - pkg
        Name:      git
        Function:  installed
            Result:    True
            Comment:   Package git is already installed
            Changes:   
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
    Succeeded: 9
    Failed:    0
    ------------
    Total:     9
    
    
##### Cmds    

    $ sudo salt 'minion-01' docker.restart f99a4e4730d6ef9d00f5369aa11af386b8fc7d538faea196953815684ca1a551
    
##### Output

    minion-01:
        ----------
        comment:
            Container f99a4e4730d6ef9d00f5369aa11af386b8fc7d538faea196953815684ca1a551 was restarted
        id:
            f99a4e4730d6ef9d00f5369aa11af386b8fc7d538faea196953815684ca1a551
        out:
            None
        status:
            True
            
    
##### Cmds

    $ sudo salt 'minion-01' cmd.run 'sudo docker logs node'
    
    
##### Output
    2013-11-24 22:43:28,555 INFO waiting for salt-minion to die
    2013-11-24 22:43:28,579 INFO stopped: salt-minion (exit status 0)
    2013-11-24 22:43:28,933 CRIT Supervisor running as root (no user in config file)
    2013-11-24 22:43:28,933 WARN Included extra file "/etc/supervisor/conf.d/node-web-skel.conf" during parsing
    2013-11-24 22:43:28,934 WARN Included extra file "/etc/supervisor/conf.d/supervisor-salt.conf" during parsing
    2013-11-24 22:43:28,953 INFO RPC interface 'supervisor' initialized
    2013-11-24 22:43:28,953 WARN cElementTree not installed, using slower XML parser for XML-RPC
    2013-11-24 22:43:28,953 CRIT Server 'unix_http_server' running without any HTTP authentication checking
    2013-11-24 22:43:28,953 INFO supervisord started with pid 1
    2013-11-24 22:43:29,957 INFO spawned: 'salt-minion' with pid 7
    2013-11-24 22:43:29,958 INFO spawned: 'node-web-skel' with pid 8
    2013-11-24 22:43:31,222 INFO success: salt-minion entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
    2013-11-24 22:43:31,223 INFO success: node-web-skel entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)


