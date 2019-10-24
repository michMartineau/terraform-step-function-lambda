This project is a playground in order.

##Requirements
aws-cli/1.16.266
Terraform v0.12.12

## AWS Configuration
You have to configure your aws credential.
```
aws configure --profile my-profile
```

## Create the infrastructure stack and deploy the lambdas
```
cd terraform-step-function-lambda
terraform init
terraform plan -out plan.txt
terraform apply "plan.txt"
```
## Destroy the stack
```
terraform destroy
```