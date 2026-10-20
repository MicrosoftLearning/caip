[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$SubscriptionId,

    [Parameter(Mandatory)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory)]
    [string]$Location,

    [Parameter(Mandatory)]
    [ValidatePattern('^[a-z0-9-]{2,64}$')]
    [string]$AccountName,

    [string]$DeploymentName = 'gpt-5-mini',
    [string]$ModelName = 'gpt-5-mini',
    [string]$ModelVersion = '2025-08-07',
    [ValidateSet('GlobalStandard', 'Standard')]
    [string]$DeploymentSku = 'GlobalStandard',
    [ValidateRange(1, 1000)]
    [int]$Capacity = 10,
    [string]$FabricSqlPrincipalId
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    throw 'Azure CLI is required. Install it before you run this script.'
}

& az account show --only-show-errors | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw 'Sign in by running az login, and then run this script again.'
}

& az account set --subscription $SubscriptionId --only-show-errors
if ($LASTEXITCODE -ne 0) {
    throw "The subscription '$SubscriptionId' is unavailable to the signed-in identity."
}

& az group create `
    --name $ResourceGroupName `
    --location $Location `
    --output none `
    --only-show-errors
if ($LASTEXITCODE -ne 0) {
    throw 'The resource group deployment failed.'
}

& az cognitiveservices account create `
    --name $AccountName `
    --resource-group $ResourceGroupName `
    --location $Location `
    --kind OpenAI `
    --sku S0 `
    --custom-domain $AccountName `
    --output none `
    --only-show-errors
if ($LASTEXITCODE -ne 0) {
    throw 'The Azure OpenAI resource deployment failed.'
}

& az cognitiveservices account deployment create `
    --name $AccountName `
    --resource-group $ResourceGroupName `
    --deployment-name $DeploymentName `
    --model-name $ModelName `
    --model-version $ModelVersion `
    --model-format OpenAI `
    --sku-name $DeploymentSku `
    --sku-capacity $Capacity `
    --output none `
    --only-show-errors
if ($LASTEXITCODE -ne 0) {
    throw 'The model deployment failed. Verify regional availability, version, and quota.'
}

$accountId = & az cognitiveservices account show `
    --name $AccountName `
    --resource-group $ResourceGroupName `
    --query id `
    --output tsv `
    --only-show-errors
if ($LASTEXITCODE -ne 0 -or -not $accountId) {
    throw 'The script could not resolve the Azure OpenAI resource ID.'
}

if ($FabricSqlPrincipalId) {
    & az role assignment create `
        --assignee-object-id $FabricSqlPrincipalId `
        --assignee-principal-type ServicePrincipal `
        --role 'Cognitive Services OpenAI User' `
        --scope $accountId `
        --output none `
        --only-show-errors
    if ($LASTEXITCODE -ne 0) {
        throw 'The Cognitive Services OpenAI User role assignment failed.'
    }
}

$endpoint = & az cognitiveservices account show `
    --name $AccountName `
    --resource-group $ResourceGroupName `
