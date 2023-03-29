#!/bin/bash
cd "$(dirname "$0")"

if [ -f ".env" ]; then
	source .env
	docker login --username $DOCKER_REPO_LOGIN --password $DOCKER_REPO_PASS $DOCKER_REPO_HOST

	cp docker-compose.yaml-example docker-compose.yaml
	sed -i "s|sputnik_repo_rtc|$SPUTNIK_REPO_RTC|g" docker-compose.yaml
	sed -i "s|rtc_ip|$RTC_IP|g" docker-compose.yaml

	./HAProxy/sed.sh $PARTNERS_DOMEN $RTC_LOCAL_URL $FS_URL $CS_URL $API_URL $MQ_URL
	./RabbitMQ/sed.sh $USERNAME_TO_SPUTNIK $PASSWORD_TO_SPUTNIK $SPUTNIK_FEDERATION_UPSTREAM $LOGIN_FROM_SPUTNIK $PASSWORD_FROM_SPUTNIK $RMQ_HOST_FROM_SPUTNIK
else
	echo "File .env does not exist."
fi
