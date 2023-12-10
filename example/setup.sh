#!/bin/bash

set -e

cd "$(dirname "$0")"

if [ -f ".env" ]; then
	source .env

	docker login --username $DOCKER_REGISTRY_LOGIN --password $DOCKER_REGISTRY_PASS $DOCKER_REGISTRY_HOST
	sed -i "s|DOCKER_REGISTRY_RTC_REPO|$DOCKER_REGISTRY_HOST/asgard-external/rtcservice:$RTC_DOCKER_IMAGE_TAG|g" docker-compose.yaml

	./HAProxy/setup.sh

	docker-compose up -d

	./RabbitMQ/setup.sh
else
	echo "File .env does not exist."
fi
