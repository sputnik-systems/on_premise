FROM haproxy:2.7-alpine

USER root
RUN apk add libcap
RUN setcap 'cap_net_bind_service=+ep' /usr/local/sbin/haproxy

USER haproxy
