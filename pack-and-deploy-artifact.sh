#!/bin/bash

# load key value pairs from node.config
source node.config

if [ -z "$( which node )" ]
then
  echo "Please install node. Run local-install-node-npm.sh"
  exit 1
fi

# pull repo if not exists
if [ ! -d cloud-basics-exercises/ ]
then
  git clone https://gitlab.com/twn-devops-bootcamp/latest/05-cloud/cloud-basics-exercises
else
  echo "Node project directory found."
fi

# package deployable
cd cloud-basics-exercises/app/
npm pack

# check if file was created
if [ ! -f bootcamp-node-project-1.0.0.tgz ]
then
  echo "Packed file not found locally. Something went wrong."
  exit 1
fi

# copy file to remote
echo "copying deployable to remote via scp."
scp bootcamp-node-project-1.0.0.tgz $NEW_USER@$REMOTE_ADDRESS:bootcamp-node-project-1.0.0.tgz

# Read User Input for service user pswd for later use
#read -p "Enter password for $NEW_USER you set up with remote-install script: " sudo_pwd

ssh $NEW_USER@$REMOTE_ADDRESS <<EOF
if [ ! -f bootcamp-node-project-1.0.0.tgz ]
then
  echo "Packed file not found on remote. Something went wrong."
  exit 1
else 
  echo "Deployable Archive found on remote. unpacking, installing..."
fi

tar -xzvf bootcamp-node-project-1.0.0.tgz 
cd package
echo "installing packages..."
npm install
echo "starting the node server..."
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

