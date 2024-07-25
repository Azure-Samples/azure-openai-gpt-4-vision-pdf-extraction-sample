targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the workload which is used to generate a short unique hash used in all resources.')
param workloadName string

@minLength(1)
@description('Primary location for all resources.')
param location string

@description('Name of the resource group. If empty, a unique name will be generated.')
param resourceGroupName string = ''

@description('Tags for all resources.')
param tags object = {}

@description('Principal ID of the user that will be granted access to the OpenAI service.')
param userPrincipalId string
@description('Primary location for the OpenAI service. Default is swedencentral for GPT-4o support.')
param openAILocation string = 'swedencentral'

var abbrs = loadJsonContent('./abbreviations.json')
var roles = loadJsonContent('./roles.json')
var resourceToken = toLower(uniqueString(subscription().id, workloadName, location))
var openAIResourceToken = toLower(uniqueString(subscription().id, workloadName, openAILocation))

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.managementGovernance.resourceGroup}${workloadName}'
  location: location
  tags: union(tags, {})
}

module managedIdentity './security/managed-identity.bicep' = {
  name: '${abbrs.security.managedIdentity}${resourceToken}'
  scope: resourceGroup
  params: {
    name: '${abbrs.security.managedIdentity}${resourceToken}'
    location: location
    tags: union(tags, {})
  }
}

resource cognitiveServicesOpenAIUser 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: resourceGroup
  name: roles.ai.cognitiveServicesOpenAIUser
}

var completionModelDeploymentName = 'gpt-4o'

module openAI './ai_ml/openai.bicep' = {
  name: '${abbrs.ai.openAIService}${openAIResourceToken}'
  scope: resourceGroup
  params: {
    name: '${abbrs.ai.openAIService}${openAIResourceToken}'
    location: openAILocation
    tags: union(tags, {})
    deployments: [
      {
        name: completionModelDeploymentName
        model: {
          format: 'OpenAI'
          name: 'gpt-4o'
          version: '2024-05-13'
        }
        sku: {
          name: 'Standard'
          capacity: 8
        }
      }
    ]
    roleAssignments: [
      {
        principalId: managedIdentity.outputs.principalId
        roleDefinitionId: cognitiveServicesOpenAIUser.id
        principalType: 'ServicePrincipal'
      }
      {
        principalId: userPrincipalId
        roleDefinitionId: cognitiveServicesOpenAIUser.id
        principalType: 'User'
      }
    ]
  }
}

output resourceGroupInfo object = {
  id: resourceGroup.id
  name: resourceGroup.name
  location: resourceGroup.location
}

output managedIdentityInfo object = {
  id: managedIdentity.outputs.id
  name: managedIdentity.outputs.name
  principalId: managedIdentity.outputs.principalId
  clientId: managedIdentity.outputs.clientId
}

output openAIInfo object = {
  id: openAI.outputs.id
  name: openAI.outputs.name
  endpoint: openAI.outputs.endpoint
  completionModelDeploymentName: completionModelDeploymentName
}
