.PHONY: init plan apply destroy build test tf_plan tf_apply tf_destroy
test:
	pip3 install -e python
	python3 -m pytest python
build:
	docker build -f docker/api/Dockerfile -t hello-world-api .
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
