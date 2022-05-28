variable AWS_REGION {}
variable S3_BUCKETNAME {}
variable PROJECT_NAME {}

terraform {
    backend "s3" {
        key = "terraform.tfstate"
    }
}

provider "aws" {
    region = var.AWS_REGION
}
