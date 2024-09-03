ECR_REPO ?= 
IMAGE_TAG ?= latest 

.PHONY: build
build:
	@docker build -t $(ECR_REPO):$(IMAGE_TAG) --file ./app/Dockerfile .
	@docker push $(ECR_REPO):$(IMAGE_TAG)

# .PHONY: deploy_wp
# deploy_wp: build
# 	@terraform destroy --target module.ecs.aws_ecs_service.default --target module.ecs.aws_ecs_task_definition.task1 --aut-approve