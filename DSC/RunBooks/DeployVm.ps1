##################################################################################
# Instructions
##################################################################################
#Import module from marketplace in automation account : AzureRM.Profile, AzureRM.Network

##################################################################################
# Param
##################################################################################
param (

[Parameter(Mandatory=$true)]
$Location,

[Parameter(Mandatory=$true)]
$ResourceGroupName,

[Parameter(Mandatory=$true)]
$VirtualNetworkAddressPrefix,

[Parameter(Mandatory=$true)]
$VirtualNetworkSubnetAddressPrefix,

[Parameter(Mandatory=$true)]
$VirtualMachineAdminUsername,

[Parameter(Mandatory=$true)]
$VirtualMachineAdminPassword,

[Parameter(Mandatory=$true)]
$ResourceOwnerNameTag,

[Parameter(Mandatory=$true)]
$BusinessUnitTag,

[Parameter(Mandatory=$true)]
$CostCenterTag,

[Parameter(Mandatory=$true)]
$EnvironmentTag,

[Parameter(Mandatory=$true)]
$MaintenanceWindowStartTag,

[Parameter(Mandatory=$true)]
$MaintenanceWindowEndTag,

[Parameter(Mandatory=$true)]
$ExpirationDateTag,

[Parameter(Mandatory=$true)]
$VirtualMachineSize,

[Parameter(Mandatory=$true)]
$VirtualMachineSKU,


[Parameter(Mandatory=$true)]
$RegistrationKey,

[Parameter(Mandatory=$true)]
$RegistrationUrl,

[Parameter(Mandatory=$true)]
$NodeConfigurationName,

[Parameter(Mandatory=$true)]
$TemplateFile

)

##################################################################################
# Connect
##################################################################################
$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint



##################################################################################
# Autogenerated Variables
##################################################################################

$randomnumber = Get-Random -Minimum 0 -Maximum 99
$envname = $ResourceGroupName -replace '[-]',''
$VirtualMachineName = $envname   + "vm"
$VirtualNetworksName = $VirtualMachineName + "vnet"
$VirtualNetworkSubnetName = $VirtualMachineName + "subvnet"

$VirtualMachineNetworkInterfacesName = $VirtualMachineName + "nic"
$VirtualMachinePublicIPAddressesName = $VirtualMachineName + "ip"

# Storage account

$StorageAccountsName = $VirtualMachineName + $randomnumber

##################################################################################
# local Variables
##################################################################################


$VirtualMachineDataDiskSize = 40
$ModulesUrl = "https://github.com/Azure/azure-quickstart-templates/raw/master/dsc-extension-azure-automation-pullserver/UpdateLCMforAAPull.zip"
$ConfigurationFunction = "UpdateLCMforAAPull.ps1\ConfigureLCMforAAPull"



$ConfigurationMode = "ApplyAndMonitor"
$ConfigurationModeFrequencyMins = 15
$RefreshFrequencyMins = 30
$RebootNodeIfNeeded = $true
$ActionAfterReboot = "ContinueConfiguration"
$AllowModuleOverwrite = $true
$timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

##################################################################################
# Parameters
##################################################################################

 $Parameters = @{
     "virtualMachineName"=$VirtualMachineName;
     "virtualNetworksName"=$VirtualNetworksName;
     "virtualNetworkAddressPrefix"=$VirtualNetworkAddressPrefix;
     "virtualNetworkSubnetName"=$VirtualNetworkSubnetName;
     "virtualNetworkSubnetAddressPrefix"=$VirtualNetworkSubnetAddressPrefix;
     "storageAccountsName"=$StorageAccountsName;
     "virtualMachineSize"=$VirtualMachineSize;
     "virtualMachineDataDiskSize"=$VirtualMachineDataDiskSize;
     "virtualMachineSKU"=$VirtualMachineSKU;
     "virtualMachineNetworkInterfacesName"=$VirtualMachineNetworkInterfacesName;
     "virtualMachinePublicIPAddressesName"=$VirtualMachinePublicIPAddressesName;
     "virtualMachineAdminUsername"=$VirtualMachineAdminUsername;
     "virtualMachineAdminPassword"="$VirtualMachineAdminPassword";
     "resourceOwnerNameTag"=$ResourceOwnerNameTag;
     "businessUnitTag"=$BusinessUnitTag;
     "costCenterTag"=$CostCenterTag;
     "environmentTag"=$EnvironmentTag;
     "maintenanceWindowStartTag"=$MaintenanceWindowStartTag;
     "maintenanceWindowEndTag"=$MaintenanceWindowEndTag;
     "expirationDateTag"=$ExpirationDateTag;
     "modulesUrl"=$ModulesUrl;
     "configurationFunction"=$ConfigurationFunction;
     "registrationKey"="$registrationKey";
     "registrationUrl"=$RegistrationUrl;
     "nodeConfigurationName"=$NodeConfigurationName;
     "configurationMode"=$ConfigurationMode;
     "configurationModeFrequencyMins"=$ConfigurationModeFrequencyMins;
     "refreshFrequencyMins"=$RefreshFrequencyMins;
     "rebootNodeIfNeeded"=$RebootNodeIfNeeded;
     "actionAfterReboot"=$ActionAfterReboot;
     "allowModuleOverwrite"=$AllowModuleOverwrite;
     "timestamp"=$Timestamp
 }

##################################################################################
# Create Resource group if needed
##################################################################################

$resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
   New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location

}
##################################################################################
# Deploy Template
##################################################################################



New-AzureRmResourceGroupDeployment -ResourceGroupName  $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterObject $Parameters
 

>