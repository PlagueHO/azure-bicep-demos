@description('The name of the storage account used by this application')
param storageAccountName string

@description('Prefix to append to all resources')
param prefix string = 'dsr'

var storageAccountNameFull = '${prefix}${storageAccountName}'

resource kv 'Microsoft.KeyVault/vaults@2021-04-01-preview' existing = {
  name: 'dsrkeyvault'
}

resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountNameFull
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }

  // Add child resource
  resource blobservice 'blobServices@2021-02-01' = {
    name: '${storageAccountNameFull}-blob'
    properties: {
      automaticSnapshotPolicyEnabled: true
    }
  }
}

output storageAccountBlobEndpoint string = mystorage.properties.primaryEndpoints.blob
