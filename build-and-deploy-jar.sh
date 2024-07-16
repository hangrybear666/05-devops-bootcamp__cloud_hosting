#!/bin/bash

# load key value pairs from java.config
source java.config

if [ -z "$( which gradle )" ]
then
  echo "Please install gradle locally.
  See https://docs.gradle.org/current/userguide/compatibility.html"
  exit 1
fi

# pull repo if not exists 
if [ ! -d java-react-example/ ]
then
  git clone https://gitlab.com/twn-devops-bootcamp/latest/05-cloud/java-react-example
else
  echo "Java project directory found."
fi

# build jar file
cd java-react-example
gradle clean build

# check if file was created
if [ ! -f build/libs/java-react-example.jar ]
then
  echo "Packed file not found locally. Something went wrong."
  exit 1
else
  echo "java-react-example.jar found in build folder."
fi

# copy file to remote
echo "copying deployable artifact to remote via scp."
scp build/libs/java-react-example.jar $NEW_USER@$REMOTE_ADDRESS:java-react-example.jar

# Read User Input for service user pswd for later use
#read -p "Enter password for $NEW_USER you set up with remote-install script: " sudo_pwd

ssh $NEW_USER@$REMOTE_ADDRESS <<EOF
if [ ! -f java-react-example.jar ]
then
  echo "Packed file not found on remote. Something went wrong."
  exit 1
else 
  echo ".jar file found on remote. Starting execution"
  java -jar java-react-example.jar &
fi

# wait for the server to start before querying processes and netstats
sleep 15

# log running JAVA process
echo "
RUNNING JAVA PROCESS:"
ps aux | head -n 1
ps aux | grep "java -jar" | grep -v grep 

echo "
to shutdown the JAVA server run 'kill PID'"

# log whatever is running on port 7071 
echo "
PORT 7071 IS RUNNING:"
netstat -ltnp | grep 7071 

EOF

