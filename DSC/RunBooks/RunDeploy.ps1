.\DeployVm.ps1 -Location "southcentralus" -ResourceGroupName "rg-dsctest7" -VirtualNetworkAddressPrefix "10.1.0.0/16" -VirtualNetworkSubnetAddressPrefix "10.1.1.0/24" `
 -VirtualMachineAdminUsername  "slalomadmin" -VirtualMachineAdminPassword "!Race2Win!" -ResourceOwnerNameTag "test" -BusinessUnitTag "test" `
 -CostCenterTag "test" -EnvironmentTag "Development" -MaintenanceWindowStartTag "Mon 23:00" -MaintenanceWindowEndTag "Tue 01:00" -ExpirationDateTag "2017-09-06 11:12:13"`
 -VirtualMachineSize "Standard_D1_v2" -VirtualMachineSKU "2012-R2-Datacenter"  `
 -RegistrationKey "WAOkQRFmqzCOswBEXCGkNK+guBEfVbA22Mwr18zNODugusEJpAJ7xfqAv12yClMylyzXXTH2bq/S7Wqp0WmIyA==" `
 -RegistrationUrl "https://scus-agentservice-prod-1.azure-automation.net/accounts/ae52f5e2-4d04-4aa4-a9c3-a4acea3fa1c2" `
 -NodeConfigurationName "MyDscConfiguration.localhost" `
 -TemplateFile "https://abcautomationstorage.blob.core.windows.net/abcautomationstoragecontainer/vmautomation_dsc.json"


