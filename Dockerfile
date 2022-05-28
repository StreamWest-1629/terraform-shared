FROM golang:bullseye

RUN \
    apt-get update && \
    apt-get install -y unzip && \
    #
    # Install aws-cli
    curl -q "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    #
    # Install Terraform
    wget -q https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip && \
    unzip -q ./terraform_1.1.7_linux_amd64.zip -d /usr/local/bin/ && \
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash && \
    git config --global credential.helper "store --file /root/.creds/.git-credentials"
