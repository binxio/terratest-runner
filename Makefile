.PHONY: docker docker-aws docker-azure push

docker: Dockerfile
	docker build -t terratest-runner:latest .

docker-aws: Dockerfile
	docker build --build-arg FILES_PATH=aws -t terratest-runner-aws:latest .

docker-gcp: Dockerfile
	docker build --build-arg FILES_PATH=gcp -t terratest-runner-gcp:latest .

docker-azure: Dockerfile
	docker build --build-arg FILES_PATH=azure -t terratest-runner-azure:latest .

docker-all: docker docker-aws docker-gcp docker-azure

push:
	docker push binxio/terratest-runner

push-aws:
	docker push binxio/terratest-runner-aws

push-gcp:
	docker push binxio/terratest-runner-gcp

push-azure:
	docker push binxio/terratest-runner-azure

push-all: push push-aws push-gcp push-azure
