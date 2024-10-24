#!/bin/sh

set -e

START="start-single-node --insecure"
JOIN_CLUSTER=

if [ "$COCKROACH_ENV" = "production" ]; then
    $START=start
    $JOIN_CLUSTER=--join=$COCKROACH_NODES
    --certs-dir=/var/lib/cockroachdb/certs
fi

cockroach $START --http-addr="$COCKROACH_HOST":"$COCKROACH_HTTP_PORT" --listen-addr="$COCKROACH_HOST":"$COCKROACH_PORT" $JOIN_CLUSTER