#!/bin/sh

SOURCE_DIR=$1
DESTINATION_DIR=$2
aws s3 cp --recursive s3://terraform-pipeline-artifacts/${SOURCE_DIR} ${DESTINATION_DIR}
