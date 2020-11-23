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
	@echo "$$GITCONFIG" > ~/.gitconfig

terragrunt_apply: gitconfig
	context_path="$1"
	terragrunt_options="$2"

	cd "$(GITHUB_WORKSPACE)/$(CONTEXT_PATH)" || exit 1; \
	terragrunt apply-all --terragrunt-non-interactive $(TERRAGRUNT_OPTIONS) || exit 1