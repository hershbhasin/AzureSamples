

$subscriptionId = "ce644727-f6f9-4d03-a4bb-f687d3eaf60d"
$resourceGroupName ="rg-reportingpoc"
$resourceGroupLocation="eastus"
$deploymentName = "reportingpoc"
$namespaceName = "reportingpocnamespace"
$eventhubName ="deviceEventHub"


###SQL Server params
$adminlogin = "harmanadmin"
$password = "!Race2Win!"
# Set server name - the logical server name has to be unique in the system
$servername = "reportingpocserver5678"  #"server-$(Get-Random)"
# The sample database name
$databasename = "devicedb"
# The ip address range that you want to allow to access your server. Enter your desktop IP here if you want to connect locally to sqlserver
$startip = "199.27.112.3"
$endip = "199.27.112.3"


# sign in
Write-Host "Logging in...";
Login-AzureRmAccount;

# select subscription
Write-Host "Selecting subscription '$subscriptionId'";
Select-AzureRmSubscription -SubscriptionID $subscriptionId;


#Create or check for existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    Write-Host "Resource group '$resourceGroupName' does not exist. To create a new resource group, please enter a location.";
    if(!$resourceGroupLocation) {
        $resourceGroupLocation = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
}
else{
    Write-Host "Using existing resource group '$resourceGroupName'";
}

# Start the deployment
Write-Host "Starting deployment...";


 
## Event Hub

New-AzureRmEventHubNamespace -ResourceGroupName $resourceGroupName -NamespaceName $namespaceName -Location $resourceGroupLocation -SkuName "Basic"
New-AzureRmEventHub -ResourceGroupName $resourceGroupName -NamespaceName $namespaceName -EventHubName $eventhubName -MessageRetentionInDays 1


###SQL Server

$server = New-AzureRmSqlServer -ResourceGroupName $resourceGroupName `
    -ServerName $servername `
    -Location $resourceGroupLocation `
    -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminlogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))

$serverfirewallrule = New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
    -ServerName $servername `
    -FirewallRuleName "AllowedIPs" -StartIpAddress $startip -EndIpAddress $endip

$database = New-AzureRmSqlDatabase  -ResourceGroupName $resourceGroupName `
    -ServerName $servername `
    -DatabaseName $databasename  -Edition "Free"
    
New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourceGroupName -ServerName $servername -AllowAllAzureIPs
