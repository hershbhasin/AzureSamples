$resourceGroup = "rg-images"
$location = "EastUS"
$storageAccountName = "hbbaseimagestorage"
$vnetName = "iaas-net"
$subnetAddress = "10.0.1.0/24"
$vnetAddress = "10.0.0.0/16"
$nicName="vm1-nic"
$vmName = "win-base"
$diskName="os-disk"

###################################################
#Login
###################################################

Login-AzureRmAccount

###################################################
#Resource Group
###################################################
New-AzureRmResourceGroup -Name $resourceGroup -Location $location

###################################################
#Storage
###################################################

New-AzureRmStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroup `
                          -Type Standard_LRS -Location $location


###################################################
#Network
###################################################
$subnet=New-AzureRmVirtualNetworkSubnetConfig -Name frontendSubnet -AddressPrefix $subnetAddress
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup -Location $location `
                                  -AddressPrefix $vnetAddress -Subnet $subnet

###################################################
#pip
###################################################

$pip = New-AzureRmPublicIpAddress -Name $nicName -ResourceGroupName $resourceGroup `
                                  -Location $location -AllocationMethod Dynamic


###################################################
#nic
###################################################
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $resourceGroup `
                                   -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id

###################################################
#vm
###################################################
$vm = New-AzureRmVMConfig -VMName $vmName -VMSize "Basic_A1"

#set admin credentials on the box
$cred=Get-Credential -Message "Admin credentials"

$vm=Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $vmName -Credential $cred `
                                 -ProvisionVMAgent -EnableAutoUpdate

$vm=Set-AzureRmVMSourceImage -VM $vm -PublisherName "MicrosoftWindowsServer" `
                             -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version "latest"

$vm=Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id


$storageAcc=Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName
$osDiskUri=$storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/" + $diskName  + ".vhd"
$vm=Set-AzureRmVMOSDisk -VM $vm -Name $diskName -VhdUri $osDiskUri -CreateOption fromImage

New-AzureRmVM -ResourceGroupName $resourceGroup -Location $location -VM $vm
