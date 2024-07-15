#!/bin/bash

# load key value pairs from app.config
source app.config

if [ -z "$( which node )" ]
then
  echo "Please install node. Run local-install-node-npm.sh"
  exit 1
fi

# package deployable
cd app/
npm pack

# check if file was created
if [ ! -f bootcamp-node-project-1.0.0.tgz ]
then
  echo "Packed file not found locally. Something went wrong."
  exit 1
fi

# copy file to remote
scp bootcamp-node-project-1.0.0.tgz $NEW_USER@$REMOTE_ADDRESS:bootcamp-node-project-1.0.0.tgz

# Read User Input for service user pswd for later use
#read -p "Enter password for $NEW_USER you set up with remote-install script: " sudo_pwd

ssh $NEW_USER@$REMOTE_ADDRESS <<EOF
if [ ! -f bootcamp-node-project-1.0.0.tgz ]
then
  echo "Packed file not found on remote. Something went wrong."
  exit 1
fi

tar -xzvf bootcamp-node-project-1.0.0.tgz 
cd package
npm install
node server.js &

# wait for the server to start before querying processes and netstats
sleep 3

# log running node process
echo "
RUNNING NODE PROCESS:"
ps aux | head -n 1
ps aux | grep server.js | grep node | grep -v grep

echo "
to shutdown the node server run 'kill PID'"

# log whatever is running on port 3000
echo "
PORT 3000 IS RUNNING:"
netstat -ltnp | grep 3000

EOF

