@description('An array of storage accounts')
param storageAccounts array

@description('Prefix to append to all resources')
param prefix string = 'dsr'

resource kv 'Microsoft.KeyVault/vaults@2021-04-01-preview' existing = {
  name: 'dsrkeyvault'
}

resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = [for storageName in storageAccounts: {
  name: '${prefix}${storageName}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}]

// Add a module to dpeloy a public IP address
param publicIpName string = 'mypublicip'

module publicIp './modules/publicIpAddress.bicep' = {
  name: 'publicIp'
  params: {
    publicIpResourceName: '${prefix}-${publicIpName}'
    dynamicAllocation: true
  }
}

output ipFqdn string = publicIp.outputs.ipFqdn
