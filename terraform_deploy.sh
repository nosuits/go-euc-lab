terraform -chdir=./terraform/vmware/infra init
terraform -chdir=./terraform/vmware/infra plan
terraform -chdir=./terraform/vmware/infra apply -parallelism=50 -auto-approve