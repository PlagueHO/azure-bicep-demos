@description('The name of the storage account used by this application')
param storageAccountName string

@description('Prefix to append to all resources')
param prefix string = 'dsr'

// Add a secure parameter
@secure()
param storageEncryptionKey string

var storageAccountNameFull = '${prefix}${storageAccountName}'

resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountNameFull
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

output storageAccountBlobEndpoint string = mystorage.properties.primaryEndpoints.blob
