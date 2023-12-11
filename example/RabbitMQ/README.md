## Настройка Rabbit MQ federation

Для настройки необходимо ввести данные команды, предварительно подставив нужные значения.
```
docker-compose exec rabbit rabbitmqctl add_user username password
docker-compose exec rabbit rabbitmqctl set_permissions -p / username ".*" ".*" ".*"
docker-compose exec rabbit rabbitmqctl set_parameter federation-upstream spuntik "{\"uri\":\"$MQ_FEDERATION_UPSTREAM_URI\",\"expires\":3600000}"
docker-compose exec rabbit rabbitmqctl set_policy --apply-to exchanges user-policy "(^sputnik$)" '{"federation-upstream-set":"all"}'
```

После этого, Rabbit MQ начнёт отсылать данные в Спутник и так же из Спутника будут прилетать данные в этот Rabbit MQ, по этому необходим внешний порт Rabbit MQ, к которому сможет подкючиться Спутник
