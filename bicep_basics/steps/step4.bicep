@description('The name of the storage account used by this application')
param storageAccountName string

resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  // Convert location parameter to expression
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
