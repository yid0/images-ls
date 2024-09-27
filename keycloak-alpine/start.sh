#!/bin/bash

set -e 

echo "staring keycloak instance on port: $KC_HTTPS_PORT"

START=start-dev

# Enable --proxy-headers only for the gateway
if [ "$KC_ENV" = "production" ]; then
    START= start --optimized
fi;

exec kc.sh start --optimized

exit 0;