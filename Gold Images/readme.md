# Creating a Gold Image

In my article DSC with Infrastructure-As-Code and Azure Automation is a potent combination http://hershbhasin.com/2017/09/dsc-with-infrastructure-as-code-and-azure-automation-is-a-potent-combination/, I outlined the limitations of using a "Gold Image" to provision your Virtual Machines. A Gold image is  a fully patched image that had all our needed software, registry settings, and configurations installed. However, keeping the machines cloned from these golden images up-to-date with latest versions of software and patches is non-trivial task, and in that article I outlined a strategy for provisioning virtual machines that are in a continual state of operational readiness using Azure Automation DSC and infrastructure as code.

However, some clients do want to continue using Gold Images. There is sometimes a reluctance to change established ways of doing things or paucity of time .  To satisfy such clients, we do need to create and provision such "Gold Images", and in this article, I show how.

# 1. Create a Windows VM



Run the provided script: Create-Windows-Vm.ps1 or create a VM from the Azure Portal

```powershell
$resourceGroup = "rg-hb-image"
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
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup -Location $location  -AddressPrefix $vnetAddress -Subnet $subnet
                   
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

```





# 2. Extract a Custom(Gold) Image

Warning: Once you generalize a vm, you cannot start it. You will then have to clone it from the resulting image.

Provided script file : Extract-VM-Image.ps1

1. RDP into the box from where image is to be extracted

2. Navigate to C:\Windows\System32\sysprep and run

   ```powershell
   .\sysprep.exe
   ```

3. select : "enter System Out-of-Box-Experience (OOBE)" in the ensuing dialogue

   1. Click  "Generalize"
   2. Shutdown Options : Shutdown

4. Check Status 

   ```powershell
   Get-AzureRmVm -ResourceGroupName $resourceGroup -Name $vmName -Status
   ```

   It will say "Vm Stopped". We should deallocate it as we are still being charged for compute.

5. Deallocate the VM

   ```powershell
   Stop-AzureRmVm  -ResourceGroupName $resourceGroup -Name $vmName 
   ```

   then check state again: it should say "Vm deallocated"

6. Run Set-AzureRmVm with the Generalized option so that Azure knows that the machine is in a good state to take a image.

   ```powershell
   Set-AzureRmVm -ResourceGroupName $resourceGroup -Name $vmName -Generalized
   ```

   Check the status again and we see that the displayStatus is "Vm generalized"

7. Now we can save the image to a storage account

   ```powershell
   Save-AzureRmVMImage -ResourceGroupName $resourceGroup -Name $vmName -DestinationContainerName "vm-images" -VHDNamePrefix "win-web-app" -Path "win-web-app.json"
   ```

   1. This will create a image in the same storage account as the current disk file, in a new container specified by the "DestinationContainerName" parameter
   2. Azure generates a random file name based on the "VHDNamePrefix" parameter
   3. Azure will save a local copy of the generated ARM template at the location specified by the  "Path" parameter. The template will contain the full URI to the new disk image. In the resulting arm template, note the image/uri location, which we will use to create vms from this image. You will provide this location in Section 3.3

   ​

   # 3. Save it in Azure as a Managed Image

   1. In the Azure Portal, click New
   2. Select "Image"
   3. In the "Create Image" window, enter the image/uri  location you noted in 2.7.3 above.

You can now query the image with this powershell:

```powershell
Get-AzureRmImage -ResourceGroupName $ImageRGName
```

To get all images in the subscription

```powershell
Get-AzureRmImage
```

To get the id of the image

```powershell
$VMImageId = (Get-AzureRmImage -ResourceGroupName $ImageRGName -ImageName $ImageName).id
```



# 4. Create a VM from the Gold Image

Run provide script : Create-VM-From-Image.ps1

```powershell


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








```

