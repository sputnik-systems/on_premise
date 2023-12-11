# create user to federate this cluster
# docker exec -it rabbitmq rabbitmqctl add_user $MQ_USERNAME $MQ_PASSWORD
# docker exec -it rabbitmq rabbitmqctl set_permissions -p / $MQ_USERNAME ".*" ".*" ".*"

# setup pulling events outside
docker exec -it rabbitmq rabbitmqctl set_parameter federation-upstream spuntik "{\"uri\":\"$MQ_FEDERATION_UPSTREAM_URI\",\"expires\":3600000}"
docker exec -it rabbitmq rabbitmqctl set_policy --apply-to exchanges user-policy "(^sputnik$)" '{"federation-upstream-set":"all"}'