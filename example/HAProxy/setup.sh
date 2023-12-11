#!/bin/bash
cd "$(dirname "$0")"

sed -i "s|CLOUD_ENDPOINTS_DOMAIN_NAME|$CLOUD_ENDPOINTS_DOMAIN_NAME|g" haproxy.cfg
sed -i "s|FS_INTERNAL_ADDRESS|$FS_INTERNAL_ADDRESS|g" haproxy.cfg
sed -i "s|CS_INTERNAL_ADDRESS|$CS_INTERNAL_ADDRESS|g" haproxy.cfg
sed -i "s|API_INTERNAL_ADDRESS|$API_INTERNAL_ADDRESS|g" haproxy.cfg
