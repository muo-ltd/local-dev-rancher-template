# Rancher Developer Starter Template

The aim of this project is to create a template development solution that will run on Docker for Mac and Docker for Windows that 
creates an instance of Rancher server locally and then adds itself as a host. It also creates an environment script to export the 
variables needed to connect to Rancher from the command line. 

*Note Docker Toolkit is not currently supported*

#Usage

## Pre-requisites Mac

* Install [Docker for Mac](https://docs.docker.com/docker-for-mac/)
* brew install make

## Pre-requisites Windows 10

* Install [Docker for Windows](https://docs.docker.com/docker-for-windows/)
* Install [Redhat Cygwin](http://www.redhat.com/services/custom/cygwin/) add make sure to select "curl" and "make" 

## Access from localhost

Running rancher on Docker for Mac/Windows will not expose ports on localhost. To get round this you can use the 
proxy. This creates an haproxy instance that passes through the ports to the host so that you can use localhost.
The haproxy is generated automatically from a list of ports either configured in the make file or by passing it
explicitly via the ports variable. 

You cannot run the proxy before deploying your system into Rancher. If you do the containers that expose ports 
to the host will not work because the proxy blocks their use. Once the system is deployed then you should start 
the proxy. 

## Make file

To make things easy I created a Makefile wrapper for the script which can then be extended. The commands are:
* `make up <ports=>` stand up Rancher server, Rancher Agent, Create Dev API key and generate a rancher-env.sh script
* `make down` tear it all down  build-proxy
* `make build-proxy <ports=>` build the proxy, either change the ports in the makefile or pass it to the make command 
* `make run-proxy <ports=>` run the proxy
* `make remove-proxy` stop and remove the proxy
* `make generate-rancher-env` re-generate a rancher-env.sh script


# Thanks
Chris Urwin - providing me with various snippets to perform Rancher tasks.  