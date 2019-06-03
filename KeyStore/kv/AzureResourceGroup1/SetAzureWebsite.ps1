param (
   [string] $AzureWebsiteName,
   [string] $slot,
   [hashtable] $appsettings
)
Set-AzureWebsite -Name $AzureWebsiteName -Slot $slot -AppSettings $appsettings