#!/bin/bash

CONFIG_DIR=$1

cd $CONFIG_DIR

PUBLIC_IP=$(terraform output -json | jq -r '.server_public_ip.value')
TIMEOUT_PERIOD=60
DELAY=2

function ping_server() {
    echo $(curl --fail $PUBLIC_IP)
}

function wait_for_server() {
    t=$TIMEOUT_PERIOD

    curl --fail $PUBLIC_IP
    until [ $? = 0 ]  ; do
        t=$((t - DELAY))
        if [[ $t -eq 0 ]]; then
            echo "====== Server is not up after $TIMEOUT_PERIOD seconds"
            exit 1
        fi

        echo "Server is not up yet, remaining time: $t seconds"
        sleep $DELAY
        curl --fail $PUBLIC_IP
    done

    echo "====== Server is up"
}

echo "====== Pinging $PUBLIC_IP"
wait_for_server
