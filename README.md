Terratest runner
---------------------------------
This is a simple docker which will run [terratest](https://github.com/gruntwork-io/terratest) for you.

Example Makefile for your module project:
```
.PHONY: test

test:
	docker run --rm -it -v ${HOME}/.aws/:/root/.aws/:ro -v $(PWD):/go/src/app/ binxio/terratest-runner:latest
```

From within your Terraform directory you can then run:
```
make test
```

The docker expects a test directory to be present within the root dir of your Terraform project.
