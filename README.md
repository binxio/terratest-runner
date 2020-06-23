Terratest runner
---------------------------------
This is a simple docker which will run [terratest](https://github.com/gruntwork-io/terratest) for you.
The source code for this docker is hosted in [GitHub](https://github.com/binxio/terratest-runner).

The docker expects a test directory to be present within the root dir of your Terraform project.

Example Makefiles
=================

AWS module:
```
SHELL := /bin/bash
  
MODULE         := $(notdir $(PWD))
USERID          = $(shell id -u)
USERGROUP       = $(shell id -g)

.PHONY: test

clear-env-error:
	$(eval ENV_ERROR =)

check-env-%:
ifeq ("${$*}", "")
	$(eval ENV_ERROR = $(ENV_ERROR)$* is not set in environment.\n)
endif

check-aws-env: clear-env-error check-env-AWS_PROFILE
ifneq ("$(ENV_ERROR)", "")
	@echo -e "$(ENV_ERROR)"
	@exit 1
endif

test: check-aws-env
	docker run --rm -it \
	-v ${HOME}/.aws/:/root/.aws/:ro \
	-v $(PWD):/go/src/app/ \
	-e AWS_PROFILE=${AWS_PROFILE} \
	-e TF_VAR_owner=$(USER) \
	binxio/terratest-runner-aws:latest
```
GCP module:
```
SHELL := /bin/bash

MODULE         := $(notdir $(PWD))
USERID          = $(shell id -u)
USERGROUP       = $(shell id -g)
GCP_CREDS_FILE  = $(notdir ${GOOGLE_APPLICATION_CREDENTIALS})

.PHONY: test

clear-env-error:
	$(eval ENV_ERROR =)

check-gcp-creds-file: $(GOOGLE_APPLICATION_CREDENTIALS)

check-env-%:
ifeq ("${$*}", "")
	$(eval ENV_ERROR = $(ENV_ERROR)$* is not set in environment.\n)
endif

check-gcp-env: check-gcp-creds-file clear-env-error check-env-GOOGLE_APPLICATION_CREDENTIALS
ifneq ("$(ENV_ERROR)", "")
	@echo -e "$(ENV_ERROR)"
	@exit 1
endif

test: check-gcp-env
	docker run --rm -it \
	-v ${GOOGLE_APPLICATION_CREDENTIALS}:/root/$(GCP_CREDS_FILE):ro \
	-v $(PWD):/go/src/app/ \
	-e GOOGLE_APPLICATION_CREDENTIALS=/root/$(GCP_CREDS_FILE) \
	-e TF_VAR_owner=$(USER) \
	binxio/terratest-runner-gcp:latest
```

From within your Terraform directory, you can then run:
```
make test
```

