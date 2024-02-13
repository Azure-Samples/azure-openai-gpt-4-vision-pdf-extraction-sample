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

@description('Name of the OpenAI Service. If empty, a unique name will be generated.')
param openAIServiceName string = ''

var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, workloadName, location))

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.resourceGroup}${workloadName}'
  location: location
  tags: union(tags, {})
}

var visionModelDeploymentName = 'gpt-4-vision-preview'

module openAI './ai_ml/openai.bicep' = {
  name: !empty(openAIServiceName) ? openAIServiceName : '${abbrs.openAIService}${resourceToken}'
  scope: resourceGroup
  params: {
    name: !empty(openAIServiceName) ? openAIServiceName : '${abbrs.openAIService}${resourceToken}'
    location: location
    tags: union(tags, {})
    deployments: [
      {
        name: visionModelDeploymentName
        model: {
          format: 'OpenAI'
          name: 'gpt-4'
          version: 'vision-preview'
        }
        sku: {
          name: 'Standard'
          capacity: 5
        }
      }
    ]
  }
}

output resourceGroupInfo object = {
  id: resourceGroup.id
  name: resourceGroup.name
  location: resourceGroup.location
}

output openAIInfo object = {
  id: openAI.outputs.id
  name: openAI.outputs.name
  endpoint: openAI.outputs.endpoint
  visionModelDeploymentName: visionModelDeploymentName
}
