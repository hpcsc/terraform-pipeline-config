#!/bin/bash

set -e

CONFIG_DIR=$1

cd $CONFIG_DIR

PUBLIC_IP=$(terraform output -json | jq -r '.server_public_ip.value')
TIMEOUT_PERIOD=30
DELAY=2

function ping_server() {
    echo $(curl $PUBLIC_IP)
}

function wait_for_server() {
    response=$(ping_server)
    t=$TIMEOUT_PERIOD
    until echo $response | jq . >/dev/null 2>&1 ; do
        t=$((t - DELAY))
        if [[ $t -eq 0 ]]; then
            echo "====== Server is not up after $TIMEOUT_PERIOD seconds"
            exit 1
        fi

        echo "Server is not up yet, remaining time: $t seconds"
        sleep $DELAY
        response=$(ping_server)
    done

    echo "====== Server is up"
}

echo "====== Pinging $PING_URL"
wait_for_server
