
$resourceGroup = "rg-images"
$vmName = "win-base"

###################################################
#Login
###################################################

#Import-AzureRmContext -Path "c:\temp\azureprofile.json"
Login-AzureRmAccount

###################################################
#Generalize
###################################################

#Run on vm : c:\windows\sysprep\sysprep.exe 

#Check Status
Get-AzureRmVm -ResourceGroupName $resourceGroup -Name $vmName -Status

#Deallocate
Stop-AzureRmVM -ResourceGroupName $resourceGroup -Name $vmName 

#Run generalize on azure
Set-AzureRmVM -ResourceGroupName $resourceGroup -Name $vmName -Generalized

#check status again
Get-AzureRmVm -ResourceGroupName $resourceGroup -Name $vmName -Status


#Save the image


Save-AzureRmVMImage -ResourceGroupName $resourceGroup -Name $vmName -DestinationContainerName "vm-images" -VHDNamePrefix "win-web-app" -Path "hb-image.json"



