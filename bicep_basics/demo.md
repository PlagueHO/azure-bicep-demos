# Demo

## Prep

```powershell
Connect-AzAccount
Select-AzSubscription -Subscription Demo
New-AzResourceGroup `
    -Name 'dsr-bicepdemo-rg' `
    -Location 'eastus'
```

## Demo Script

1. Decompile template:

```sh
bicep decompile vm.json
```

1. Add resource:

```bicep
resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'dsrstorage'
  location: 'eastus'
  kind:'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
```

1. Add parameter:

```bicep
@description('The name of the storage account used by this application')
param storageAccountName string = 'dsrstorage'

resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: 'eastus'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
```

1. Add parameter:

```bicep
@allowed([
  'eastus'
  'westus'
])
param location string = 'eastus'

resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind:'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
```

1. Remove location parameter and convert location to expression:

```bicep
resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
```

1. Add new parameter:

```bicep
@description('Prefix to append to all resources')
param prefix string = 'dsr'
```

1. Change name parameter to concatenated string:

```bicep
resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: '${prefix}${storageAccountName}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
```

1. Add variable for storage account name:

```bicep
var storageAccountFullName = '${prefix}${storageAccountName}'

resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountFullName
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
```

1. Add output variable:

```bicep
output storageAccountBlobEndpoint string = mystorage.properties.primaryEndpoints.blob
```

1. Add a `@Secure()` parameter:

```bicep
@secure()
param storageEncryptionKey string
```

1. Demonstrate `existing` by adding properties to storage account:

```bicep
resource kv 'Microsoft.KeyVault/vaults@2021-04-01-preview' existing = {
  name: 'dsrkeyvault'
}
```

```bicep
  properties: {
    encryption: {
      services: {
        blob: {
          enabled: true
        }
      }
      keySource:'Microsoft.Keyvault'
      keyvaultproperties:{
        keyname: 'storageaccountencryptionkey'
        keyvaulturi: kv.properties.vaultUri
      }
    }
  }
```

1. Demonstrate child resource by adding:

```bicep
  resource blobservice 'blobServices@2021-02-01' = {
    name: '${storageAccountNameFull}-blob'
    properties: {
      automaticSnapshotPolicyEnabled: true
    }
  }
```

1. Remove child resource.

1. Demonstrate 'parent' method of adding a resource:

```bicep
resource blobservice 'Microsoft.Storage/storageAccounts/blobServices@2021-02-01' = {
  name: '${storageAccountNameFull}-blob'
  parent: mystorage
  properties: {
    automaticSnapshotPolicyEnabled: true
  }
}
```

1. Add loop:

```bicep
@description('An array of storage accounts')
param storageAccounts array
```

```bicep
resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = [for storageName in storageAccounts: {
  name: '${prefix}${storageName}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}]
```

1. Add module:

```bicep
param publicIpName string = 'mypublicip'

module publicIp './modules/publicIpAddress.bicep' = {
  name: 'publicIp'
  params: {
    publicIpResourceName: '${prefix}-${publicIpName}'
    dynamicAllocation: true
  }
}

output ipFqdn string = publicIp.outputs.ipFqdn
```

1. Compile file:

```sh
bicep build main.bicep --outfile azuredeploy.json
```

1. Deploy file:

```powershell
Connect-AzAccount
Select-AzSubscription -Subscription Demo
New-AzResourceGroup `
    -Name 'dsr-bicepdemo-rg' `
    -Location 'eastus'
New-AzResourceGroupDeployment `
    -TemplateFile main.bicep `
    -storageAccounts @('app','logs') `
    -ResourceGroupName 'dsr-bicepdemo-rg'
```
