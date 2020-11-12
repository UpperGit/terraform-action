CONTEXT_PATH ?=
TERRAGRUNT_OPTIONS ?= --terragrunt-debug

all:

.PHONY: terragrunt_apply

docker_image: Dockerfile
	docker build -t terraform:latest --network host .

terragrunt_apply:
	context_path="$1"
	terragrunt_options="$2"

	cd "$(GITHUB_WORKSPACE)/$(CONTEXT_PATH)" || exit 1; \
	terragrunt apply-all --terragrunt-non-interactive --terragrunt-source /modules/ $(TERRAGRUNT_OPTIONS); \
	terragrunt output-all --terragrunt-non-interactive --terragrunt-tfpath /terraform_wrapper --terragrunt-source /modules/ $(TERRAGRUNT_OPTIONS) ; \
	OUTPUT_CONTENT=$(shell cat terraform.log) ; \
	echo "::set-output name=state_output::$(OUTPUT_CONTENT)"