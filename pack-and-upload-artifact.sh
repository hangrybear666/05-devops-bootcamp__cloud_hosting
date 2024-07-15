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

ssh $NEW_USER@$REMOTE_ADDRESS <<EOF
if [ ! -f bootcamp-node-project-1.0.0.tgz ]
then
  echo "Packed file not found on remote. Something went wrong."
  exit 1
fi
EOF

