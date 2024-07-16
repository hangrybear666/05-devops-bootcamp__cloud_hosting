#!/bin/bash

# load key value pairs from java.config
source java.config

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
  echo "$NEW_USER ALL=(ALL:ALL) ALL" | sudo EDITOR="tee -a" visudo
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

# ssh into remote with newly created user to download Java and Gradle 
ssh $NEW_USER@$REMOTE_ADDRESS <<EOF
echo "$NEW_USER_PW" | sudo -S apt-get install -y openjdk-17-jdk-headless
which_java=\$(which java)
installations=\$(java --version)

if [ -z "\$installations" ] || [ -z "\$which_java" ]
  then
    is_java_installed=false
  else
    is_java_installed=true
fi

if [ "\$is_java_installed" = true ]
  then
    echo "java install path: \$which_java"
    echo -e "installed java versions: \n\$installations"
  else
    echo "no java version installed"
fi

#head -n 1: Takes the first line of input
#awk -F '"' '{print \$2}': Splits Input by double quote character and prints the second field
java_version_num=\$(java -version 2>&1 | grep -i version | head -n 1 | awk -F '"' '{print \$2}')

#awk -F '.' '{print \$1}': splits the input by dots and prints the first field
java_major_version=\$( echo \$java_version_num | awk -F '.' '{print \$1}' )

if [ ! -z "\$java_major_version" ] && [ "\$java_major_version" -ge 11 ]
  then
    installation_successful=true
    echo "Java Installation Successful."
    echo "java major version: \$java_major_version"
  else
    installation_successful=false
    echo "Installation error. Java Major Version 11 or greater not installed."
fi

EOF

