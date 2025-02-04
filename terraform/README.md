# Terraform excercises

[Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/)

Azure Provider requires `subscription_id` property to run plan/apply.
Can be defined as `ARM_SUBSCRIPTION_ID` envvar:

```bash
export ARM_SUBSCRIPTION_ID="MY_SUBSCRIPTION_ID"
```

**NOTE**: Azure can create _hidden_ resources, which will not be deleted by `terraform`
(obviously: terraform didn't create them). This may require manual clean up.
