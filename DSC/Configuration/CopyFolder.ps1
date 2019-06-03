Configuration DownloadInstallPackages
{
   $storageCredential = Get-AutomationPSCredential -Name "DSCPackageStorage"
   $sourcePath = Get-AutomationVariable –Name 'DownloadPackagesPath'

    Node "localhost"
    {
       
        File DirectoryCopy
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Type = "Directory" # Default is "File".
            Checksum = "ModifiedDate"
            MatchSource = $true
            Force = $true
            Recurse = $true # Ensure presence of subdirectories, too
            Credential = $storageCredential
            SourcePath = $sourcePath
            DestinationPath = "C:\ccmsetup"    
        }
        Log AfterDirectoryCopy
        {
            # The message below gets written to the Microsoft-Windows-Desired State Configuration/Analytic log
            Message = "Finished running the file resource with ID DirectoryCopy"
            DependsOn = "[File]DirectoryCopy" # This means run "DirectoryCopy" first.
        }
       
       Package Install_Ccmsetup
        {
            Ensure = "Present"
            Name = "ccmsetup"
            DependsOn = "[File]DirectoryCopy"
            Path = "C:\ccmsetup\CCMSetup.exe"
            Arguments = "/mp:SVRSCCM1P001.ABC.amerisourcebergen.com SMSSITECODE=ABC FSP=SVRSCCM1P001 SMSSLP=SVRSCCM1P001 dnssuffix=abc.amerisourcebergen.com resetkeyinformation=true"
            ProductId = ""
        }

        Log AfterInstall_Ccmsetup
        {
            # The message below gets written to the Microsoft-Windows-Desired State Configuration/Analytic log
            Message = "Finished running the file resource with ID Install_Ccmsetup"
            DependsOn = "[Package]Install_Ccmsetup" 
        }
    }
}