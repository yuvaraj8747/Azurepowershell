# Modify for your environment. The 'registryName' is the name of your Azure
# Container Registry, the 'resourceGroup' is the name of the resource group
# in which your registry resides, and the 'servicePrincipalName' can be any
# unique name within your subscription (you can use the default below).
$registryName = "<container-registry-name>"
$resourceGroup = "<resource-group-name>"
$servicePrincipalName = "acr-service-principal"

# Configure the secure password for the service principal
$password = [guid]::NewGuid().Guid
$secpassw = ConvertTo-SecureString $password -AsPlainText -Force

# Get a reference to the container registry; need its fully qualified ID
# when assigning the role to the principal in a subsequent command.
$registry = Get-AzContainerRegistry -ResourceGroupName $resourceGroup -Name $registryName

# Create the service principal
$sp = New-AzADServicePrincipal -DisplayName $servicePrincipalName -Password $secpassw

# Sleep a few seconds to allow the service principal to propagate throughout
# Azure Active Directory
Start-Sleep 15

# Assign the role to the service principal. Default permissions are for docker
# pull access. Modify the 'RoleDefinitionName' argument value as desired:
# acrpull:     pull only
# acrpush:     push and pull
# Owner:       push, pull, and assign roles
$role = New-AzRoleAssignment -ObjectId $sp.Id -RoleDefinitionName acrpull -Scope $registry.Id

# Output the service principal's credentials; use these in your services and
# applications to authenticate to the container registry.
Write-Host "Service principal ID:" $sp.ApplicationId
Write-Host "Service principal passwd:" $password
