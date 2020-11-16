# Infrastructure as automation

This action automates infrastrucuture orchestration by providing shared terraform modules and a terragrunt DRY practices boilerplate.  It uses GitHub Actions pipelines to apply infrastructure updates, so you can easily have:

- 1 branch mapping to 1 exclusive private environment
- 1 PR mapping to 1 temporary test environment
- Keep your shared infrastructure in one or more repositories
- Keep your per-service infrastructure in the same repository of the application with minimal impact to developer's project structure
- Create a real multi-provider experience integrated to the SDLC

This repository is justing cooking some flavorful ingredients: **Terraform, Terragrunt, Docker, GitHub Actions.**

--------------------

**Table of contents**

- [Infrastructure as automation](#infrastructure-as-automation)
	- [Concept](#concept)
	- [Inputs](#inputs)
		- [`terragrunt_options`](#terragrunt_options)
		- [`path`](#path)
		- [`gitconfig`](#gitconfig)
	- [Outputs](#outputs)
		- [`state_output`](#state_output)
	- [Live example](#live-example)
	- [An author's note](#an-authors-note)

## Concept

The main goal of the project is to create a NoOps experience with infrastructure orchestration. If a thing is not infrastructure as code (state declaration) it must be infrastructure as automation (state transition trigger).

## Inputs

### `terragrunt_options`

**Required:heavy_exclamation_mark:** Options to pass for *terragrunt* command execution. Default `--terragrunt-debug`.

### `path`

**Required:heavy_exclamation_mark:** Which directory to use as context (current working directory relative to [$GITHUB_WORKSPACE](https://docs.github.com/en/free-pro-team@latest/actions/reference/environment-variables) value). Default `''`.

### `gitconfig`

Optional gitconfig file content, useful for private repository authentication when the terragrunt/terraform module source is a git URI. Default:

```
[url "https://git@github.com"]
    insteadOf = "ssh://git@github.com"
[url "https://YOUR_PERSONAL_ACCESS_TOKEN@github.com"]
    insteadOf = "ssh://private@github.com"
```

## Outputs

### `state_output`

The latest output from `terragrunt output-all` command. You can use this value to get outputs from terraform modules and configure something on your app or any other flow.

## Live example

This repository is also a *proof of concept*, so if you have a look at [.github/workflows/main.yml](.github/workflows/main.yml) file you'll see a workflow declaration to apply the modules of this repository to a Google Cloud project using an Amazon AWS S3 as backend to the terraform state.

And some considerations about the side effects and requirements of this action:

1. We don't require **any** terragrunt module project structure, you can specify where to execute `terragrunt apply-all` command using the [path](#path). This path is relative to the root of your repository.
2. To setup credentials you can use the standard authentication method of each terraform provider (as they follow the 12 app factor configuration principle). The workflow of this repository uses GitHub Secrets integration with GitHub Actions to retrieve sensitive values during *"apply time"*.
3. To get the benefits from terragrunt's `read_terragrunt_config(find_in_parent_folders())` function call you can implement the same configuration as this repository does to `owner.hcl` file. First we create a secret (`OWNER_HCL`) with the file content and through a job's step we create the file where it need to be placed.
4. If you want to use the action from other repositories you can't leave the `uses: ./` in the workflow declaration. You must put the pattern: `UpperGit/terraform-modules@VERSION_TAG` where `VERSION_TAG` substring can be something like `v1`.

## An author's note

> The important thing about this project is the concept, you can easily modify anything to your flavor by forking or cloning it, things done here are highly based on our experience and free to be discussed.