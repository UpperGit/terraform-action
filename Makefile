CONTEXT_PATH ?=
TERRAGRUNT_OPTIONS ?= --terragrunt-debug

all:

.PHONY: terragrunt_apply

docker_image: Dockerfile
	docker build -t terraform:latest --network host .

terragrunt_apply:
	context_path="$1"
	terragrunt_options="$2"

	mkdir -p ~/.ssh; \
	ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts

	cd "$(GITHUB_WORKSPACE)/$(CONTEXT_PATH)" || exit 1; \
	terragrunt apply-all --terragrunt-non-interactive $(TERRAGRUNT_OPTIONS) || exit 1; \
	terragrunt output-all --terragrunt-non-interactive --terragrunt-tfpath /terraform_wrapper $(TERRAGRUNT_OPTIONS) || exit 1; \
	OUTPUT_CONTENT=$(shell cat terraform.log); \
	echo "::set-output name=state_output::$(OUTPUT_CONTENT)"