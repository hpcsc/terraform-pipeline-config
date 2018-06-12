#!/bin/sh

PIPELINE_LABEL=$1
CONFIG_DIR=$2

cd ${CONFIG_DIR}
PACKER_BUILD_NO=$(echo ${PIPELINE_LABEL} | cut -d '.' -f1)
echo yes | terraform apply -var "packer_build_number=${PACKER_BUILD_NO}"
