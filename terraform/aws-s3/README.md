# Create an S3 bucket on AWS

- S3 bucket with versioning and website config;
- website content;
- bucket policy;
- lifecycle config;
- replication;

## Deploy, check and clean

Deploy:

```bash
terraform init
terraform plan -out=main.tfplan
terraform apply "main.tfplan"
...
Outputs:

website_url = "andreynautilus-s3-demo-v2.XXX.amazonaws.com"
```

Check:

Use `http://andreynautilus-s3-demo-v2.XXX.amazonaws.com` in browser.

Destroy:

```bash
terraform destroy
```
