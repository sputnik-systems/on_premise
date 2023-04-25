## Схема работы и возможность отказоустойчивости
<p align="center"><img width="708" alt="scheme" src="https://user-images.githubusercontent.com/73711327/230797620-77506420-50e8-4a76-9111-34d7dcccbf15.png"></p>
Для удобства и отказоустойчивости, была выбрана данная схема, где домофон, обращается к балансировщику нагрузки - HAProxy, тот уже проксирует все запросы к нужному сервису или, если их несколько, балансирует нагрузку между экземплярами сервисов. Для добавления новых экземпляров (или отключения старых), достаточно запустить дополнительный контейнер любого сервиса, и указать его адрес в файле haproxy.cfg

## Для запуска RTC необходимо:
1) Запросить .env файл и подложить его в папку example
2) Запустить скрипт setup-credentials.sh, который авторизуется в docker registry и заменяет параметры системы во всех конфигурационных и исполняемых файлах 
3) Запустить контейнеры командой docker-compose up -d 
4) Настроить Rabbit MQ с помощью команд - [ТУТ](example/RabbitMQ/README.md)
5) Передать в Спутник - IP или доменный адрес вашего RabbitMQ. Логин и пароль пользователя для доступа к federation plugin указывается в .env, если вы его поменяли, его так же нужно передать. 

После выполнения этих операций, панель может обращаться к IP или доменному адресу вашего HAProxy
Эндпоинты будут выглядеть так: 

- http:// адрес HAProxy :80 - RTC
- http:// адрес HAProxy :81 - FS
- http:// адрес HAProxy :82 - CS
- http:// адрес HAProxy :83 - API

Для проверки, можно запустить скрипт:
```
 [ $(curl -s localhost:80/liveness -w "%{http_code}" -o /dev/null) == "200" ] && echo RTC Ok || echo RTC not Ok
 [ $(curl -s localhost:81 -w "%{http_code}" -o /dev/null) == "403" ] && echo FS Ok  || echo FS not Ok
 [ $(curl -s localhost:82 -w "%{http_code}" -o /dev/null) == "404" ] && echo CS Ok  || echo CS not Ok
 [ $(curl -s localhost:83 -w "%{http_code}" -o /dev/null) == "200" ] && echo API Ok || echo API not Ok
```
## Docker compose file:
Все значения для настройки передаются в файле .env, но если необходимо, можно запустить контейнер с другими настройками, указав их в секции environment
```
  rtc:
    image: sputnik-repo
    environment:
      - MQ_HOST=${RABBITMQ_HOST}
      - MQ_USER=${RABBITMQ_USERNAME}
      - MQ_PASSWORD=${RABBITMQ_PASSWORD}
      - RTC_IP_ADDRESS=${IP_FOR_SIP} 
      - RTC_NS_ADDRESS="77.88.8.8,77.88.8.1"
      - RTP_START_PORT=4000
      - SIP_PORT=5440
      - PJSIP_LOG_LEVEL=6
      - GRAPHQL_URL=http://${HAPROXY_IP}:83/query
      - GRAPHQL_TOKEN=${GRAPHQL_TOKEN}
    ports:
      - "8080:8080" # Metrics
      - "8010:8010" # API
    healthcheck:
      test: curl --fail http://localhost:8010/liveness || exit 1
      interval: 10s
      timeout: 10s
```
## Metrics
Приложение RTC отдаёт свои метрики, в формате строки Prometheus, на порту 8080/metrics, их список приведён ниже:

1. cgo_calls_total (counter)			**_Number of cgo calls._**
2. rtc_active_calls_total (gauge)		**_Number of currently active SIP calls._**
3. rtc_active_intercoms_total (gauge)	**_Number of currently online intercoms._**
4. rtc_analog_calls_duration (gauge)	**_Average duration of SIP calls._**
5. rtc_cluster_call_duration (gauge)		**_Average durations of cluster calls._**
6. rtc_failed_analog_calls (counter)		**_Number of failed analog calls._**
7. rtc_failed_cluster_calls (counter)		**_Number of failed cluster calls_**
8. rtc_failed_sip_calls (counter)		**_Number of failed SIP calls._**
9. rtc_rmq_fatal_errors (counter)		**_The number of fatal errors occurred_**
10. rtc_rmq_msgs_consumed (counter)	**_The number of received messages_**
11. rtc_rmq_msgs_published (counter)	**_The number of published messages per_**
12. rtc_sip_calls_duration (gauge)		**_Average duration of SIP calls._**
13. rtc_speak_analog_calls (counter)		**_Number of connected SIP calls._**
14. rtc_speak_cluster_calls (counter)		**_Number of connected cluster calls._**
15. rtc_speak_sip_calls (counter)		**_Number of connected SIP calls._**
16. rtc_started_analog_calls (counter)	**_Number of started analog calls._**
17. rtc_started_cluster_calls (counter)	**_Number of started cluster calls._**
18. rtc_started_sip_calls (counter)		**_Number of started SIP calls._**

## WatchTower

1. Для того, что бы автоматически следить за появлением свежих версий RTC и их обновлением, рекомендуется использовать приложение watchtower или аналоги, в папке example, приведён пример использования. 
