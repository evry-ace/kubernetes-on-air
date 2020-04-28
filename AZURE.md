## Kubernetes on Air on Azure

```
az account set -s <subscription-id>
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$AZ_SUB_ID"
```
