@description('The name of the storage account used by this application')
param storageAccountName string

@description('Prefix to append to all resources')
param prefix string = 'dsr'

var storageAccountNameFull = '${prefix}${storageAccountName}'

// Add reference to existing key vault
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
  // Add properties to enable storage key encryption
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
}

output storageAccountBlobEndpoint string = mystorage.properties.primaryEndpoints.blob
