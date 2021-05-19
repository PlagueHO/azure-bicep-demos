param publicIpName string = 'mypublicip'

module publicIp './modules/publicIpAddress.bicep' = {
  name: 'publicIp'
  params: {
    publicIpResourceName: publicIpName
    dynamicAllocation: true
    // Parameters with default values may be omitted.
  }
}

// To reference module outputs
output ipFqdn string = publicIp.outputs.ipFqdn

param keyVaultName string
param keyVaultSubscription string
param keyVaultResourceGroup string
param secret1Name string
param secret1Version  string
param secret2Name string


// Passing a Key Vault secret to a module parameter
resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
  scope: resourceGroup(keyVaultSubscription, keyVaultResourceGroup)
}

module secretModule './modules/secret.bicep' = {
  name: 'secretModule'
  params: {
    myPassword: kv.getSecret(secret1Name, secret1Version)
    mySecondPassword: kv.getSecret(secret2Name)
  }
}
