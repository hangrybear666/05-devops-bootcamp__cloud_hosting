# Basic Cloud Hosting in Linux VM on DigitalOcean

This repo contains simple Bash Script files to establish an ssh connection to a cloud hosted linux virtual machine. After having established connection, some programs such as node are installed, a deployment package is copied via scp and then run on the remote machine.

## Setup

1. Pull SCM

Pull the repository locally by running 
```
  git clone https://github.com/hangrybear666/05-devops-bootcamp__cloud_hosting.git 
```

2. Create Remote Linux VPS and configure

	Generate local ssh key and add to remote VPS's `authorized_keys` file.

3. Install additional dependencies on remote

	Some Linux distros ship without the `netstat` command we use. In that case run `apt install net-tools`

## Usage (Demo Projects)

1. Add your Remote Hostname and IP to app.config

	First, you have to add the IP address of your remote machine and the root user to `java.config` file.

2. Install Java with a newly created user account on remote server

	To install dependencies remotely, run `./remote-install-java.sh`

3. Install Gradle locally.
	Make sure to check https://docs.gradle.org/current/userguide/compatibility.html for the correct version for java 17. I can recommend using SDKMAN! to install different versions of gradle on linux. https://sdkman.io/install

4. Build Artifact and Deploy remotely.

	To build a .jar, push it to remote and start the server, run `./build-and-deploy-jar.sh`

## Usage (Exercises)

1. Add your Remote Hostname and IP to app.config

	First, you have to add the IP address of your remote machine and the root user to `node.config` file.

2. Install Node and NPM with a newly created user account on remote server

	To install node and npm via Node Version Manager (NVM) in a new service account on the remote machine simply run `./remote-install-node-npm.sh`
 
3. Install Node and NPM locally with Node Version Manager (NVM)

	To install locally, simply run `./local-install-node-npm.sh`. Then restart your terminal.

4. Package App and Upload to remote server, starting as a service in the background

	To package the node app into an archive, upload it to the server via scp, unpack and start the server simply run `./pack-and-deploy-artifact.sh`

5. To kill the running server check the logs from step 3 for its Process ID (PID).

	To kill the node server, run `kill <PID>` on the remote server.
