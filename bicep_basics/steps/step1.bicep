// Create basic resource
resource mystorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'dsrstorage'
  location: 'eastus'
  kind:'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
