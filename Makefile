.PHONY: init plan apply destroy build test tf_plan tf_apply tf_destroy

export ACCOUNT := $(shell aws sts get-caller-identity --query Account --output text)
export REGION := $(shell aws configure get region)
export REPO := hello-world-api

# Installs and runs test on api
test:
	pip3 install -e python
	python3 -m pytest python
## Builds the image
build:
	docker build -f docker/api/Dockerfile -t hello-world-api .
## Builds and pushes image to ECR
push:
	@echo "This will build the image and push it to ECR. Do you want to proceed? [y/N]" && read ans && [ $${ans:-N} = y ]
	docker build -f docker/api/Dockerfile -t ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO} .

	aws ecr get-login-password \
		--region ${REGION} \
	| docker login \
		--username AWS \
		--password-stdin ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com

	docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}

## Terraform related commands
init:
	if [ ! -d "terraform/.terraform" ]; then terraform -chdir=terraform init; fi
tf_plan:
	terraform -chdir=terraform plan
tf_apply:
	terraform -chdir=terraform apply
tf_destroy:
	terraform -chdir=terraform destroy

plan: init build tf_plan
apply: init build tf_apply
destroy: init tf_destroy
