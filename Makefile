CONTEXT_PATH ?=
TERRAGRUNT_OPTIONS ?= --terragrunt-debug
KNOWN_HOSTS ?= github.com

# Custom SSH private key
# SSH_PRIVATE_KEY ?= 

all:

.PHONY: ssh_keys terragrunt_apply

docker_image: Dockerfile
	docker build -t terraform:latest --network host .

ssh_keys:
	mkdir -p ~/.ssh

	if [ -n "$$SSH_PRIVATE_KEY" ]; then \
		ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''; \
	else \
		echo $$SSH_PRIVATE_KEY > ~/.ssh/id_rsa; \
	fi
	
	chmod 600 ~/.ssh/id_rsa

	for remote_host in "$$KNOWN_HOSTS"; do \
		ssh-keyscan -t rsa "$$remote_host" >> ~/.ssh/known_hosts; \
	done
	

terragrunt_apply: ssh_keys
	context_path="$1"
	terragrunt_options="$2"

	cd "$(GITHUB_WORKSPACE)/$(CONTEXT_PATH)" || exit 1; \
	terragrunt apply-all --terragrunt-non-interactive $(TERRAGRUNT_OPTIONS) || exit 1; \
	terragrunt output-all --terragrunt-non-interactive --terragrunt-tfpath /terraform_wrapper $(TERRAGRUNT_OPTIONS) || exit 1; \
	OUTPUT_CONTENT=$(shell cat terraform.log); \
	echo "::set-output name=state_output::$(OUTPUT_CONTENT)"