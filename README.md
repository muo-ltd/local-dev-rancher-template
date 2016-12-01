# Rancher Developer Starter Template

The aim of this project is to create a template development solution that will run on Docker for Mac and Docker for Windows that 
creates an instance of Rancher server locally and then adds itself as a host. It also creates an environment script to export the 
variables needed to connect to Rancher from the command line. 

*currently ports exposed are not reachable*

*Note Docker Toolkit is not currently supported*

#Usage

## Pre-requisites Mac

* Install [Docker for Mac](https://docs.docker.com/docker-for-mac/)
* brew install make

## Pre-requisites Windows 10

* Install [Docker for Windows](https://docs.docker.com/docker-for-windows/)
* Install [Redhat Cygwin](http://www.redhat.com/services/custom/cygwin/) add make sure to select "curl" and "make" 

## Make file

To make things easy I created a Makefile wrapper for the script which can then be extended. The commands are:
* `make up` stand up Rancher server, Rancher Agent, Create Dev API key and generate a rancher-env.sh script
* `make down` tear it all down
* `make generate-rancher-env` re-generate a rancher-env.sh script

# Thanks
Chris Urwin - providing me with various snippets to perform Rancher tasks.  