## Настройка Rabbit MQ federation

Для настройки необходимо ввести данные команды, предварительно подставив нужные значения.
```
docker-compose exec rabbit rabbitmqctl add_user username password
docker-compose exec rabbit rabbitmqctl set_permissions -p / username ".*" ".*" ".*"
docker-compose exec rabbit rabbitmqctl set_parameter federation-upstream staging-asgard '{"uri":"amqp://$SPUTNIK_RMQ_LOGIN:$SPUTNIK_RMQ_PASS@$SPUTNIK_RMQ_HOST:$
docker-compose exec rabbit rabbitmqctl set_policy --apply-to exchanges user-policy "(^sputnik$)" '{"federation-upstream-set":"all"}'
```

После этого, Rabbit MQ начнёт отсылать данные в Спутник и так же из Спутника будут прилетать данные в этот Rabbit MQ, по этому необходим внешний порт Rabbit MQ, к которому сможет подкючиться Спутник
