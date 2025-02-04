# Create a single linux VM

Create resources:

```bash
export ARM_SUBSCRIPTION_ID="MY_SUBSCRIPTION_ID"

terraform init
terraform plan -out=main.tfplan
terraform apply "main.tfplan"
```

and destroy:

```bash
terraform destroy
```
