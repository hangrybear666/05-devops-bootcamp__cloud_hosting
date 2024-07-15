#!/bin/bash

# load key value pairs from app.config
source app.config

PUBLIC_KEY=$(cat $HOME/.ssh/id_rsa.pub)

# ask for user input to avoid password exposure in git
read -p "Please provide password for new user $NEW_USER: " NEW_USER_PW

ssh $ROOT_USER@$REMOTE_ADDRESS <<EOF
# reset prior user and the respective home folder
userdel -r $NEW_USER

#create new user
useradd -m $NEW_USER

# add sudo privileges to service user
sudo cat /etc/sudoers | grep $NEW_USER

if [ -z "\$( sudo cat /etc/sudoers | grep $NEW_USER )" ]
then
  echo "node-runner ALL=(ALL:ALL) ALL" | sudo EDITOR="tee -a" visudo
  echo "$NEW_USER added to sudoers file."
else 
  echo "$NEW_USER found in sudoers file."
fi

echo "$NEW_USER:$NEW_USER_PW" | chpasswd

# switch to new user
su - $NEW_USER

# add public key to new user's authorized keys
mkdir .ssh
cd .ssh
touch authorized_keys
echo "created .ssh/authorized keys file"
echo "$PUBLIC_KEY" > authorized_keys
echo "added public key to authorized_keys file of new user."
EOF

# ssh into remote with newly created user to download Node Version Manager (NVM)
ssh $NEW_USER@$REMOTE_ADDRESS <<EOF
# download nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
EOF

# restart ssh shell so newly added nvm command can be found
ssh $NEW_USER@$REMOTE_ADDRESS <<EOF
#install node and npm
nvm install 22
EOF
