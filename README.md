# Basic Cloud Hosting in Linux VM on DigitalOcean

This repo contains simple Bash Script files to establish an ssh connection to a cloud hosted linux virtual machine. After having established connection, some programs such as node are installed, a deployment package is copied via scp and then run on the remote machine.

## Setup

Pull the repository locally by running 
```
  git clone https://github.com/hangrybear666/05-devops-bootcamp__cloud_hosting.git 
```

## Usage

1. Install Node and NPM with a newly created user account on remote server

	To install node and npm via Node Version Manager (NVM) in a new service account on the remote machine simply run `./remote-install-node-npm.sh`.
 

