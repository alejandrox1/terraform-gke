TF_PLAN := a.plan


.PHONY: all
all:
	terraform init
	terraform plan -out $(TF_PLAN)

.PHONY: clean
clean:
	rm -f $(TF_PLAN)

.PHONY: clean-all
clean-all: clean
	terraform destroy
