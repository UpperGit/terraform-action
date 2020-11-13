FROM debian:stable-slim

ARG TERRAFORM_VERSION=0.13.5
ARG TERRAGRUNT_VERSION=0.25.5

RUN \
	# Update
	apt-get update -y && \
	# Install dependencies
	apt-get install make unzip wget -y

################################
# Install Terraform
################################

# Download terraform for linux
RUN wget --progress=dot:mega https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN \
	# Unzip
	unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
	# Move to local bin
	mv terraform /usr/local/bin/ && \
	# Make it executable
	chmod +x /usr/local/bin/terraform && \
	# Check that it's installed
	terraform --version

################################
# Install Terragrunt
################################

# Download terragrunt for linux
RUN wget --progress=dot:mega https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64

RUN \
	# Move to local bin
	mv terragrunt_linux_amd64 /usr/local/bin/terragrunt && \
	# Make it executable
	chmod +x /usr/local/bin/terragrunt && \
	# Check that it's installed
	terragrunt --version

COPY terraform_wrapper /terraform_wrapper
COPY Makefile /Makefile

ENTRYPOINT ["make", "-C", "/"]

LABEL "com.github.actions.name"="Infrastructure as automation"
LABEL "com.github.actions.description"="Upper automated terraform infrastructure orchestrator"
LABEL "com.github.actions.icon"="robot"
LABEL "com.github.actions.color"="blue"
LABEL "repository"="https://github.com/UpperGit/terraform-modules"
LABEL "homepage"="https://github.com/UpperGit/terraform-modules"
LABEL "maintainer"="https://github.com/UpperGit"