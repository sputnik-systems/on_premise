# create user to federate this cluster
# docker exec -it rabbitmq rabbitmqctl add_user $MQ_USERNAME $MQ_PASSWORD
# docker exec -it rabbitmq rabbitmqctl set_permissions -p / $MQ_USERNAME ".*" ".*" ".*"

# setup pulling events outside
docker exec -it rabbitmq rabbitmqctl set_parameter federation-upstream sputnik "{\"uri\":\"$MQ_FEDERATION_UPSTREAM_URI\",\"expires\":3600000}"
docker exec -it rabbitmq rabbitmqctl set_parameter federation-upstream intercom_missed "{\"uri\":\"$MQ_FEDERATION_UPSTREAM_URI\"}"
docker exec -it rabbitmq rabbitmqctl set_policy --apply-to exchanges sputnik-input "^(sputnik)$" '{"federation-upstream":"sputnik","alternate-exchange":"intercom_missed"}'
docker exec -it rabbitmq rabbitmqctl set_policy --apply-to exchanges intercom_missed-input "^(intercom_missed)$" '{"federation-upstream":"intercom_missed"}'
docker exec -it rabbitmq rabbitmqctl set_policy --apply-to all cleanup "^(missed_queue|logs|webhook-logs)$" '{"max-length-bytes":134217728,"message-ttl":600000}'
