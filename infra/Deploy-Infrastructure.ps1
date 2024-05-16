<#
.SYNOPSIS
    Deploy the core infrastructure for the OpenAI GPT-4 with Vision Sample to an Azure subscription.
.DESCRIPTION
    This script initiates the deployment of the main.bicep template to the current default Azure subscription,
    determined by the Azure CLI. The deployment name and location are required parameters.
.PARAMETER DeploymentName
    The name of the deployment to create in an Azure subscription.
.PARAMETER Location
    The location to deploy the Azure resources to.
.EXAMPLE
    .\Deploy-Infrastructure.ps1 -DeploymentName 'my-deployment' -Location 'swedencentral'
.NOTES
    Author: James Croft
    Date: 2024-05-15
#>

param
(
    [Parameter(Mandatory = $true)]
    [string]$DeploymentName,
    [Parameter(Mandatory = $true)]
    [string]$Location
)

Write-Host "Starting infrastructure deployment..."

Push-Location -Path $PSScriptRoot

az --version

$userPrincipalId = ((az rest --method GET --uri "https://graph.microsoft.com/v1.0/me") | ConvertFrom-Json).id

$deploymentOutputs = (az deployment sub create --name $DeploymentName --location $Location --template-file './main.bicep' `
        --parameters './main.parameters.json' `
        --parameters workloadName=$DeploymentName `
        --parameters location=$Location `
        --parameters userPrincipalId=$userPrincipalId `
        --query 'properties.outputs' -o json) | ConvertFrom-Json
$deploymentOutputs | ConvertTo-Json | Out-File -FilePath './InfrastructureOutputs.json' -Encoding utf8

Pop-Location

return $deploymentOutputs