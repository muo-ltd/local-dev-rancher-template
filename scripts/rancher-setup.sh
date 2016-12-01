#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function stopAndDeleteContainerByPartialImageName() {
	local IMAGE_NAME=$1
	echo "Stopping and removing $IMAGE_NAME"
	for ID in $(docker ps | tail -n+2 | awk '{$2 ~ /rancher\//; print $1 }'); do
		docker stop $ID
	done
	for ID in $(docker ps | tail -n+2 | awk '{$2 ~ /rancher\//; print $1 }'); do
		docker stop $ID
	done
	for ID in $(docker ps -a | tail -n+2 | awk '{$2 ~ /rancher\//; print $1 }'); do
		docker rm $ID
	done
}

function deleteDanglingVolumes() {
	for ID in $(docker volume ls -qf dangling=true); do
		docker volume rm $ID
	done
}

function cleanUnusedImages() {
	echo "Cleaning old images"
	for ID in $(docker images | grep -E '<none>' | grep -v 'latest' | awk '{ print $3 }'); do
		sh -c "docker rmi -f $ID; exit 0;"
	done
}

function createRancherServer() {
	echo "Pulling Rancher Server Latest"
	docker pull rancher/server:latest
	echo "Running Rancher Server"
	docker run -d \
			   --restart=unless-stopped \
			   --name rancherserver \
			   -p 8080:8080 \
			   -e "CATTLE_API_HOST=http://192.168.65.2:8080" rancher/server

}

function waitForRancherToStart() {
	local TIME=0
	echo "Waiting for Rancher Server to start (expected 40-120 secs to start)"
	until $(curl --output /dev/null --silent --head --fail http://localhost:8080); do
		TIME=$[$TIME + 1]
        sleep 1
		printf '\r'; printf "Waited $TIME secs"
	done
	echo " "	
	echo "Rancher Server Started"
}

function addLocalAsHost() {
	local COMMAND
	echo "Adding host to Rancher Server"
	echo "Set host to be custom"
	curl -XPOST -H 'Content-Type: application/json' -H 'accept: application/json' -d '{"type":"registrationToken"}' 'http://localhost:8080/v1/projects/1a5/registrationtoken'
	sleep 3
	echo "Extract host command"
	curl --silent http://localhost:8080/v1/projects/1a5/registrationtokens > rancher.txt
	echo "Execute add command"
	cat rancher.txt | awk -F, '{for (i=1;i<=NF;i++)print $i}' | grep command | awk '{ gsub("\"", ""); gsub("command:sudo ", ""); print}' | sh
	rm -f rancher.txt 
	echo "Localhost Added"
}

function createRancherApiKey() {

	echo "Creating API key for user dev"
    curl --silent -k -i --raw -o keys.dat -XPOST -H 'Content-Type: application/json' -H 'x-api-project-id: 1a5' -H 'accept: application/json' -H "Content-type: application/json" -d '{"type":"apikey","accountId":"1a5","name":"dev","description":"dev","created":null,"kind":null,"removed":null,"uuid":null}' 'http://localhost:8080/v1/apikey'

    echo "Getting API Username and password"
    ACCESS_KEY=$(cat keys.dat | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'publicValue'\042/){print $(i+1)}}}' | tr -d '"' | sed -n 1p)
	SECRET_KEY=$(cat keys.dat | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'secretValue'\042/){print $(i+1)}}}' | tr -d '"' | sed -n 1p)
    
	rm -f keys.dat
    if [ -f "rancher-env.sh" ]; then
        rm rancher-env.sh
    fi

    echo export LD_RANCHER_ACCESS_KEY=$ACCESS_KEY\; >> rancher-env.sh
    echo export LD_RANCHER_SECRET_KEY=$SECRET_KEY\; >> rancher-env.sh
    echo export RANCHER_ACCESS_KEY=$ACCESS_KEY\; >> rancher-env.sh
    echo export RANCHER_SECRET_KEY=$SECRET_KEY\; >> rancher-env.sh
}

function up() {
	createRancherServer
	waitForRancherToStart
	addLocalAsHost
	createRancherApiKey
	echo "Complete"
}

function down() {
	stopAndDeleteContainerByPartialImageName rancher
	echo "Complete"
}

$@
