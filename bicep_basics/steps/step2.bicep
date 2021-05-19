// Convert storage account name to parameter
@description('The name of the storage account used by this application')
param storageAccountName string = 'dsrstorage'

resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  // Convert to parameter
  name: storageAccountName
  location: 'eastus'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
