#!/bin/bash
cd "$(dirname "$0")"
cp setup.sh-example setup.sh

sed -i "s|username_to_sputnik|$1|g" setup.sh
sed -i "s|password_to_sputnik|$2|g" setup.sh
sed -i "s|sputnik_federation_upstream|$3|g" setup.sh
sed -i "s|login_from_sputnik|$4|g" setup.sh
sed -i "s|password_from_sputnik|$5|g" setup.sh
sed -i "s|rmq_host_from_sputnik|$6|g" setup.sh
