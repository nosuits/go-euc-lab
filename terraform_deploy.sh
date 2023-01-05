terraform -chdir=./terraform/vmware/infra init
terraform -chdir=./terraform/vmware/infra plan
terraform -chdir=./terraform/vmware/infra apply -parallelism=8-auto-approve