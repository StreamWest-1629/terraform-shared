#!/bin/sh

terraform plan \
    -var AWS_REGION=${AWS_REGION} \
    -var S3_BUCKETNAME=${S3_BUCKETNAME} \
    -var PROJECT_NAME=${PROJECT_NAME}