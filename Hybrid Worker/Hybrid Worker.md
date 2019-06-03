# Azure Automation Hybrid Runbook Worker

MS Docs : https://docs.microsoft.com/en-us/azure/automation/automation-hybrid-runbook-worker



1. In the Azure Portal, create an Azure Automation account, note its Resource Group Name & Automation Account Name.  Currently the only Automation regions supported for integration with OMS are - **Australia Southeast**, **East US 2**, **Southeast Asia**, and **West Europe**, so location has to be one of these.

   Example:

   1. Automation Account  Name: abcautomation

   2. Resource Group :  rg-hb-util

   3. Location : East Us 2 *

      ​

      ​

2. Create a OMS account there is a free trial available. You should create it in the same region as your automation account.  

   1. Sign up url: https://www.microsoft.com/en-us/cloud-platform/operations-management-suite-trial
   2. There will be a prompt to "Select Azure Subscription", with prompts "Link", "Create New". Select **Link**

   ​

   ​

3. Create a Windows 10 RS2 Pro (x64) vm from the marketplace

   1. Name : HW1
   2. Give it a public IP :  HW1-IP

4. Remote into the machine.  

5. If you try to launch browsers Microsoft Edge & you get "Windows 10 Edge can’t be opened using the built-in administrator account", follow these steps to allow browser to open on Windows 10.

   Under Local Policies/Security Options navigate to “User Account Control Admin Approval Mode for the Built-in Administrator account And Enable it. Restart of VM is required. Refer to:

   https://www.virtualizationhowto.com/2015/07/windows-10-edge-opened-builtin-administrator-account/

6. Download powershell script called  New-OnPremiseHybridWorker.ps1 from Powershell gallery:

   https://www.powershellgallery.com/packages/New-OnPremiseHybridWorker/1.0/Content/New-OnPremiseHybridWorker.ps1

7. The following parameters should be provided to this script

   ```powershell
     $ResourceGroupName ="the rg of the automation account"
      $SubscriptionID = "your-sub-id"
      $WorkspaceName ="a new oms workspace will be created with the name you provide here. It should be unique to your account i.e. a workspace with this name should not already exist."
      $AutomationAccountName ="name of your automation account"
      $HybridGroupName ="A named group will be created with the name you provide i.g. Tenant-Provisioning"
   ```


1. On the box, run the following powershell commands (to enable running scripts)

   ```powershell
    Set-ExecutionPolicy RemoteSigned
   ```

2. Run the  powershell called New-OnPremiseHybridWorker.ps1 on new vm, providing the parameters  specified in 5. Important: run the powershell  as **Administrator** or install of MS Monitoring Agent  will fail. The script will download nuget packages, ask you to log into Azure with your credentials, then set up a OMS workspace and register the vm as a Hybrid Worker.

3. If you go to the automation account in the Azure portal and look under the tab: "Hybrid worker groups", you will see the group you specified in $HybridGroupName with Number of Workers = 1.



### (Optional) Install Required software on the Hybrid Machine

1. MSOnline (if you want to work with Azure Active Directory)

   Download link:  http://connect.microsoft.com/site1164/Downloads/DownloadDetails.aspx?DownloadID=59185

2. Microsoft Active Directory Authentication Library for Microsoft SQL Server (If you want to work with SQL Server)

   Download link: https://www.microsoft.com/en-us/download/confirmation.aspx?id=48742

If you get : Unable to load adalsql.dll then follow: https://stackoverflow.com/questions/45578395/unable-to-load-adalsql-dll-error-when-calling-invoke-sqlcmd
need to uninstall &  reinstall Microsoft Active Directory Authentication Library for Microsoft SQL Server
from here https://www.microsoft.com/en-us/download/confirmation.aspx?id=48742

### Install Custom Modules on the Hybrid Machine

1. If you have a  a custom module called " XYZ.Tenant.Management.psm1"

2. This should be put into a folder called "XYZ.Tenant.Management"

    Refer to Rules For Installing Modules Docs: https://msdn.microsoft.com/en-us/library/dd878350

3. This folder should be copied to the powershell path on the Hybrid worker vm

   1. This path is usually : C:\Program Files\WindowsPowerShell\Modules

   2. To find  the path you can run this:

      ```powershell
      $Env:PSModulePath
      [Environment]::GetEnvironmentVariable("PSModulePath")
      ```

