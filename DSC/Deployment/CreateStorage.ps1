#This script creates a storage account and uploads the ARM template

##################################################################################
# Login
##################################################################################
#Login-AzureRmAccount

#or if you have stored your credentials
Import-AzureRmContext -Path "c:\temp\azureprofile.json"

##################################################################################
# Params
##################################################################################

$ResourceGroupName = "rg-abc-dsc-automation"

$Location = "southcentralus"

##################################################################################
# variables
##################################################################################

#$randomnumber = Get-Random -Minimum 0 -Maximum 99

$StorageAccountName =  "abcautomationstorage" 
 
$StorageContainername = $StorageAccountName + "container"

# Find the local folder where this PowerShell script is stored.


##################################################################################
# Storage
##################################################################################

$StorageAccount = @{
    ResourceGroupName = $ResourceGroupName;
    Name = $StorageAccountName;
    SkuName = 'Standard_LRS';
    Location =  $Location;
    }
New-AzureRmStorageAccount @StorageAccount;


### Obtain the Storage Account authentication keys using Azure Resource Manager (ARM)
$Keys = Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceGroupName -Name  $StorageAccountName;

### Use the Azure.Storage module to create a Storage Authentication Context
$StorageContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $Keys[0].Value;


### Create a storage Blob Container in the Storage Account
New-AzureStorageContainer -Context $StorageContext -Name $StorageContainername  -Permission Container;


##################################################################################
# Upload the template file
##################################################################################

### Upload a file to the Microsoft Azure Storage Blob Container
$UploadFile = @{
    Context = $StorageContext;
    Container = $StorageContainername ;
    File = ".\vmautomation_dsc.json";
    }
Set-AzureStorageBlobContent @UploadFile;

