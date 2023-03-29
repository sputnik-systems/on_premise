FROM rabbitmq:management
# enable federation plugin
RUN rabbitmq-plugins enable rabbitmq_federation
# enable federation management plugin to be able to see information about configured federations later in UI
RUN rabbitmq-plugins enable rabbitmq_federation_management
# enable monitoring plugin
RUN rabbitmq-plugins enable rabbitmq_prometheus
