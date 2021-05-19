@description('The name of the storage account used by this application')
param storageAccountName string = 'dsrstorage'

// Add location parameter with allowed list
@allowed([
  'eastus'
  'westus'
])
param location string = 'eastus'

resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  // Convert location to parameter
  location: location
  kind:'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
