FROM golang:alpine

ARG FILES_PATH=files
ARG TERRAFORM_VERSION=0.12.26
ENV TERRAFORM_VERSION=$TERRAFORM_VERSION

# Get terraform, dep
RUN apk --no-cache add curl git unzip gcc g++ make ca-certificates && \
    curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh && \
    \
    mkdir tmp && \
    curl "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o tmp/terraform.zip && \
    unzip tmp/terraform.zip -d /usr/local/bin && \
    rm -rf tmp/

ARG GOPROJECTPATH=/go/src/app
COPY $FILES_PATH $GOPROJECTPATH/test

WORKDIR $GOPROJECTPATH

RUN GO111MODULE=on go get -u github.com/gruntwork-io/terratest/cmd/terratest_log_parser && \
	# Get terratest (and test) dependencies and move them out of the way so we can mount over /go/src/app
	cd test && dep ensure -v && mv vendor/* /go/src

CMD ["go", "test", "-v", "./test"]
