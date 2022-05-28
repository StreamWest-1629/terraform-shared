#!/bin/sh

cd /workspace &&
terraform init \
    -backend-config=profile=${AWS_PROFILE} \
    -backend-config=bucket=${S3_BUCKETNAME} \
    -backend-config=region=${AWS_REGION} &&

terraform apply \
    -var AWS_REGION=${AWS_REGION} \
    -var S3_BUCKETNAME=${S3_BUCKETNAME} \
    -var PROJECT_NAME=${PROJECT_NAME}
