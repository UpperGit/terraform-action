CONTEXT_PATH ?=
TERRAGRUNT_OPTIONS ?= --terragrunt-debug
GITCONFIG ?= 

# Custom SSH private key
# SSH_PRIVATE_KEY ?= 

all:

.PHONY: gitconfig terragrunt_apply

.SILENT: gitconfig

docker_image: Dockerfile
	docker build -t terraform:latest --network host .

gitconfig:
	@echo $$GITCONFIG > ~/.gitconfig

terragrunt_apply: gitconfig
	context_path="$1"
	terragrunt_options="$2"

	cat ~/.gitconfig

	cd "$(GITHUB_WORKSPACE)/$(CONTEXT_PATH)" || exit 1; \
	terragrunt apply-all --terragrunt-non-interactive $(TERRAGRUNT_OPTIONS) || exit 1; \
	terragrunt output-all --terragrunt-non-interactive --terragrunt-tfpath /terraform_wrapper $(TERRAGRUNT_OPTIONS) || exit 1; \
	OUTPUT_CONTENT=$(shell cat terraform.log); \
	echo "::set-output name=state_output::$(OUTPUT_CONTENT)"