# Rancher Developer Starter Project

The aim of this project is to create a template development solution that will run on Docker for Mac that creates an instance of Rancher
server locally and then adds itself as a host. It also creates an environment script to export the variables needed to connect to
Rancher from the command line. 

#Usage

## Pre-requisites 

* Install Docker for Mac
* brew install make

## Make file

To make things easy I created a Makefile wrapper for the script which can then be extended. The commands are:
* `make up` stand up Rancher server, Rancher Agent, Create Dev API key and generate a rancher-env.sh script
* `make down` tear it all down
* `make generate-rancher-env` re-generate a rancher-env.sh script

# Thanks
Chris Urwin for providing me with various snippets to perform Rancher tasks.  