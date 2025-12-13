# Terraform exercises

[Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/)

```bash
# show current logged in account
az account show

# login via browser
az login
```

Azure Provider requires `subscription_id` property to run plan/apply.
Can be defined as `ARM_SUBSCRIPTION_ID` envvar:

```bash
# fish shell
export ARM_SUBSCRIPTION_ID=(az account show --query='id' -o=tsv)
echo $ARM_SUBSCRIPTION_ID
```

**NOTE**: Azure can create _hidden_ resources, which will not be deleted by `terraform`
(obviously: terraform didn't create them). This may require manual clean up.

## AWS authentication

Via credentials file (`~/.aws/credentials`) in AWS CLI.

- install AWS CLI if not already;
- authenticate with AWS CLI: `aws configure` and follow the prompts.
  This will create the credentials file (`~/.aws/credentials`) with `default` profile.
