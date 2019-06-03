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
            DestinationPath = "C:\PackagesTest"    
        }
        Log AfterDirectoryCopy
        {
            # The message below gets written to the Microsoft-Windows-Desired State Configuration/Analytic log
            Message = "Finished running the file resource with ID DirectoryCopy"
            DependsOn = "[File]DirectoryCopy" # This means run "DirectoryCopy" first.
        }
       
        Package Install_FireEye
        {
            Ensure = "Present"
            Name = "xagt"
            DependsOn = "[File]DirectoryCopy"
            Path = "C:\Packages\FireEye\xagtSetup_21.33.7_universal.msi"
            Arguments = "/q"
            ProductId = "55E1EF02-DA68-46D3-8659-6A29822F65C1"
        }
    }
}