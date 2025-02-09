# Create a single linux VM

We will use SSH to login into VM, so we need to generate ssh key pair:

```bash
ssh-keygen -t ed25519 -f linuxvm
```

Create resources:

```bash
export ARM_SUBSCRIPTION_ID="MY_SUBSCRIPTION_ID"

terraform init
terraform plan -out=main.tfplan
terraform apply "main.tfplan"
...
Outputs:

public_ip = "A.B.C.D"
```

Connect:

```bash
ssh adminuser@A.B.C.D -i linuxvm
```

Destroy:

```bash
terraform destroy
```
