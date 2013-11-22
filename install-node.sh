#!/bin/sh
wget http://nodejs.org/dist/v0.10.22/node-v0.10.22-linux-x64.tar.gz
tar zxvf node-v0.10.22-linux-x64.tar.gz
mv node-v0.10.22-linux-x64 /opt/node

ln -s /opt/node/bin/node /bin/node
ln -s /opt/node/bin/npm /bin/npm

npm install -g coffee-script bower express
