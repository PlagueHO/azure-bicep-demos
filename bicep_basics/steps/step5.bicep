@description('The name of the storage account used by this application')
param storageAccountName string

// Add prefix parameter
@description('Prefix to append to all resources')
param prefix string = 'dsr'

resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  // Convert to expression
  name: '${prefix}${storageAccountName}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
