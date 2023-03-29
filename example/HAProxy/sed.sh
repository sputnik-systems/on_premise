#!/bin/bash
cd "$(dirname "$0")"
cp haproxy.cfg-example haproxy.cfg

sed -i "s|partner.example|$1|g" haproxy.cfg
sed -i "s|rtc:8010|$2|g" haproxy.cfg

sed -i "s|fs-sputnik.example:443|$3|g" haproxy.cfg
sed -i "s|cs-sputnik.example:443|$4|g" haproxy.cfg
sed -i "s|api-sputnik.example:443|$5|g" haproxy.cfg
sed -i "s|mq-sputnik.example:443|$6|g" haproxy.cfg
