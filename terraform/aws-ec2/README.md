# Create an EC2 instance on AWS

- couple of Security Groups (http only and http+ssh);
- EC2 instance with SSH access, and http server via User Data;

## Prerequisites

- an SSH key-pair named `main` should already exist (created upfront);

## Authentication

**Option 1**: credentials file (`~/.aws/credentials`) in AWS CLI.

- install AWS CLI if not already;
- authenticate with AWS CLI: `aws configure` and follow the prompts.
  This will create the credentials file (`~/.aws/credentials`) with `default` profile.

## Deploy, check and clean

Deploy:

```bash
terraform init
terraform plan -out=main.tfplan
terraform apply "main.tfplan"
...
Outputs:

public_ip = "A.B.C.D"
public_nds = "ec2-XXX.eu-west-1.compute.amazonaws.com"
```

Connect:

```bash
ssh ec2-user@A.B.C.D -i linuxvm
# or
curl http://A.B.C.D
```

Destroy:

```bash
terraform destroy
```
