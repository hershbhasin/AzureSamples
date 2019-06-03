

$VMNameSuffix = "Inf"
$SrcUri = ""
$VmSize = "Standard_A1" 
$LocalMachineAdminAcctPwd = "Password123456"
$RgLocation = "eastus"

#Landlord
$VNetName ="myvnet"

#Image
$ImageRGName = "rg-images"
$ImageName = "MyImage"


########################################################
# Login Runbook
########################################################

#Login-AzureRmAccount

Import-AzureRmContext -Path "c:\temp\azureprofile.json"

########################################################
#  Varianbles
########################################################

$businessunit = "yyABDC"
$UseCase =  "wqOPSCA" 
$RGLocation = "eastus" 


########################################################
# Global Varianbles
########################################################


$tenant         = "Tenant_"

$TenantName     = "$businessunit"+"-"+"$UseCase"

$RGNames = @{"RGLocation"    = $RGLocation;
            "RGNameVM"      = $tenant+$businessunit+"_"+$UseCase+"_VM";
           
}

########################################################
# Varianbles
########################################################

$VMName = $TenantName+ "-" + $VMNameSuffix;

$PIPName = $TenantName+"_" + $VMName + "_Public_IP_Address";

$NICName = $TenantName+"_" + $VMName + "_Network_Interface";

$PIPLockName = $TenantName + "_" + $VMName + "_Public_IP_Address_Lock";

$NICLockName = $TenantName + "_" + $VMName + "_Network_Interface_Lock";

$VMLockName  = $TenantName + "_" + $VMName + "_VM_Lock";

$ComputerName = ($businessunit + "-" + $VMName).Substring(0,14);


$pip = New-AzureRmPublicIpAddress -ResourceGroupName $RGNames.RGNameVM -Name $PIPName -Location $RGLocation -AllocationMethod Dynamic

#subnet
$subnet=New-AzureRmVirtualNetworkSubnetConfig -Name frontendSubnet -AddressPrefix 10.0.1.0/24

#vnet
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $RGNames.RGNameVM -Location $RGLocation `
                                  -AddressPrefix 10.0.0.0/16 -Subnet $subnet

$nic = New-AzureRmNetworkInterface -ResourceGroupName $RGNames.RGNameVM -Name $NICName -SubnetId $vnet.Subnets[0].Id  -Location $RGNames.RGLocation -PublicIpAddressId $pip.Id

#image
$VMImageId = (Get-AzureRmImage -ResourceGroupName $ImageRGName -ImageName $ImageName).id


#vm

$NewVm = New-AzureRmVMConfig -VMName $VmName -VMSize "Standard_A1"

#Creds
$Secure_String_Pwd = ConvertTo-SecureString $LocalMachineAdminAcctPwd -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential (“SuperAdmin”, $Secure_String_Pwd)

#os
$NewVm = Set-AzureRmVMOperatingSystem -VM $NewVm -Windows -ComputerName $ComputerName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate  

#nic
$NewVm = Add-AzureRmVMNetworkInterface -VM $NewVm -Id $nic.Id


#image
$VMImageId = (Get-AzureRmImage -ResourceGroupName $ImageRGName -ImageName $ImageName).id

$NewVm = Set-AzureRmVMSourceImage -VM $NewVm -Id $VMImageId

$NewVm = Set-AzureRmVMOSDisk -VM $NewVm -StorageAccountType StandardLRS -DiskSizeInGB 128 -CreateOption FromImage -Caching ReadWrite


New-AzureRmVM -ResourceGroupName $RGNames.RGNameVM -Location $RGNames.RGLocation -VM $NewVm







