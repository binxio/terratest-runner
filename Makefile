.PHONY: docker push

docker: Dockerfile
	docker build -t terratest-runner:latest .

push:
	docker push binxio/terratest-runner
