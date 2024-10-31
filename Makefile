.PHONY: init
init:
	terraform init -reconfigure

.PHONY: plan
plan:
	terraform plan

.PHONY: apply
apply:
	terraform apply

.PHONY: val
val:
	terraform validate

.PHONY: fmt
fmt:
	terraform fmt -recursive
