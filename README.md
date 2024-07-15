# Basic Cloud Hosting in Linux VM on DigitalOcean

This repo contains simple Bash Script files to establish an ssh connection to a cloud hosted linux virtual machine. After having established connection, some programs such as node are installed, a deployment package is copied via scp and then run on the remote machine.

## Setup

Pull the repository locally by running 
```
  git clone https://github.com/hangrybear666/05-devops-bootcamp__cloud_hosting.git 
```

## Usage

1. Add your Remote Hostname and IP to app.config

	First, you have to add the IP address of your remote machine and the root user to `app.config` file.

2. Install Node and NPM with a newly created user account on remote server

	To install node and npm via Node Version Manager (NVM) in a new service account on the remote machine simply run `./remote-install-node-npm.sh`.
 
3. Install Node and NPM locally with Node Version Manager (NVM)

	To install locally, simply run `./local-install-node-npm.sh`. Then restart your terminal.

4. Package App and Upload to remote server, starting as a service in the background

	To package the node app into an archive, upload it to the server via scp, unpack and start the server simply run `./pack-and-upload-artifact.sh`.

5. To kill the running server check the logs from step 3 for its Process ID (PID).

	To kill the node server, run `sudo kill <PID>` on the remote server.
