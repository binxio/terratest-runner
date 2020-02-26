.PHONY: docker docker-aws docker-azure push

docker: Dockerfile
	docker build -t terratest-runner:latest .

docker-aws: Dockerfile
	docker build --build-arg FILES_PATH=aws -t terratest-runner-aws:latest .

docker-azure: Dockerfile
	docker build --build-arg FILES_PATH=azure -t terratest-runner-azure:latest .

push:
	docker push binxio/terratest-runner

push-aws:
	docker push binxio/terratest-runner-aws

push-azure:
	docker push binxio/terratest-runner-azure
