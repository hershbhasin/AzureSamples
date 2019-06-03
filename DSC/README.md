# DSC with Infrastructure-As-Code and  Azure Automation is a winning combination

**Author: Hersh Bhasin**

www.hershbhasin.com

#Introduction



When we provision a new virtual machine, there needs to be pieces of software preinstalled on it ,or the machines needs to have some required network settings,   some required  features , some configuration settings, or some registry setting to be always present.  We would like to avoid manually installing and configuring these pieces of software and settings.

Once we provision these machines with these  set of "desired" features, something like a thermostat should exists on these machines  that maintains them in this golden state, and prevent what we call "configuration drift".

Our server documentation should be "auto-documenting". There should be a magical document that keeps itself up to date with any changes we make on our servers. We should be able to version our servers, and be able to go back to a prior version if necessary.

Infrastructure as code, Desired State Configuration (DSC), and automation,used together,   fulfills these needs for  state management, versioning and  auto-documenting   for virtual machines.

In the past  we had our "golden image", which was a fully patched image that had all our needed software, registry settings, and configurations installed.  However, keeping the machines cloned from these golden images up-to-date with latest versions of software and patches was a non-trivial task.  This is where infrastructure-as-code plays its part. With script, be it an ARM template, a Powershell script, or a Terraform script, we can create our servers in code, doing away with these "golden images".

And, to keep these scripted  machines in a state of continual deployment readiness, up-to-date with the required installs, patches and configuration settings, we use a process called Desired State Configuration (DSC).  

The underlying idea of a DSC Pull model (there is a Push model also, which is beyond the scope of this post), is this: that  there is a server somewhere that holds a magical document called a "DSC Configuration" document, in which we detail what state we want our servers to continually be in. (What software should be preinstalled, what registry settings ... should exist on the server ).

On the virtual machine that requires its state to be maintained, there exists a agent called a Local Configuration Manager (LCM) that constantly polls the DSC server and "pulls" down this magic DSC Configuration document , reads it, and applies the instructions in this document to the machine it manages. Since it is constantly polling the pull server, it reapplies any fresh instructions, or reverts back the machine to the "golden state", if someone inadvertently or maliciously attempts to change the machines utopia.

Auto-Documentation is an attribute of this magic DSC Configuration document (and also of infrastructure-as-code). In the past, when we were standing up hard physical servers, from our "gold images", the knowledge of building these servers was codified in elaborate forms, and updating these documents was never optimal.  The person who owned that knowledge was like a key man. Instead of writing a paragraph describing how the server was built, why not create document that is also functional, while describing how the server is built: this DSC Configuration document is essentially a script and it is automatically  self describing: it lists out what needs to get  installed on the virtual machine, and then makes it happen. 

The DSC Configuration document makes versioning of servers easy.  Versions of the configuration  documents can be source controlled and we  can always go back to earlier state if something fails. We can easily look at history of our server changes  in source control.

And, Automation makes the setting up of a DSC server trivial. There is no setting up to do as an automation account in Azure automatically provisions a DSC pull server.

This article first gives a introduction on using DSC with Azure Automation. It then describes a way to fully automate the creation of a virtual machine using an ARM template which has a DSC extension for adding the virtual machine as a node to the DSC pull server, so that it is managed by it. We should be able to click a  Run Book that does all this work, and that will be described.



#DSC With Automation Quick Start

##Create an Azure Automation Account

1. Create an Azure Automation account from portal.azure.com

2. A DSC pull server will also be created. You will see a section called "CONFIGURATION MANAGEMENT" with three navigation links. These are:

   1. DSC nodes

   2. DSC configurations

   3. DSC node configurations

      pic : dsc-1

I will call these links "DSC Sections" , and since they are so similar in their names, will refer to them in full.



# Create a DSC Configuration file

A DSC Config file is a simple text file that has instructions as in the examples below.

A few sample DSC Config files have been provided in the source code download, in the Configuration folder.

###CreateFileDemo.ps1

This file shows how to refer to a Automation Variable called "DownloadPackagesPath" and urite it out to a text file on the server at the path specified in the "DestinationPath." 

Automation variables allow us to pass in input variables to the DSC Configuration files.

You create a Variable from the "Variables" link on the Automation account and enter the Name, Type & Value. In this case we created a variable called "DownloadPackagesPath" with the value of some file share path.

```powershell
Configuration CreateFileDemo
{

   $samplestr = Get-AutomationVariable –Name 'DownloadPackagesPath'

    Node "localhost"
    {
       
        File CreateFile {
            DestinationPath = 'C:\myTest.txt'
            Ensure = "Present"
            Contents = $samplestr
        }
       
    }
}
```


Here are the instructions to import & compile this sample file:

1. From this code download, import the file called CreateFileDemo.ps1 to the **DSC  Configurations** section in your-automation-account (or paste the above into a text file and import).

2. When Imported, click on it, compile it by choosing Compile on the Toolbar. Let it default for the ComputerName ("Default will be used").

    (Note:the screen does not automatically refresh.  


Instead of repeating the Microsoft documentation, I point you to the relevant quick-start document on the MS site. It is a simple click-thru guide and it is here:

https://docs.microsoft.com/en-us/azure/automation/automation-dsc-getting-started

## Creating and Onboarding a machine manually

The basic steps are: you create a virtual machine and add the machine to the DSC Node of the automation account. Once added, it will be automatically managed by the DSC Server, based on state specified in the DSC Configuration file.

Later, I will show how to automatically provision a vm and add it to the DSC Server using an ARM template with the DSC extension. However to get a quick feel of how the DSC stuff works, you can provision a vm manually from the Azure portal and manually add it to the DSC Nodes section of the automation account. 

Instead of repeating the Microsoft documentation, I point you to the relevant quick-start document on the MS site. It is a simple click-thru guide and it is here:

https://docs.microsoft.com/en-us/azure/automation/automation-dsc-getting-started



# Seeing  the DSC maintain state

Once the machine is onboarded, and a valid and compiled DSC Configuration exists, the LSM on the virtual machine will pull the Configuration file and apply it.

The machine you onboarded should appear in the DSC Nodes section with a status of "Compliant". If you remote into the virtual machine, you should see the file c:\myTest.txt.

###A more complex DSC Configuration

Suppose you want a software called FireEye to be installed on all your DSC managed servers. You would create a Azure file share. You will upload the FireEye installer files to this file share. You will create a Automation Credential Asset ( similar to how we created the variable asset DownloadPackagesPath) by clicking the Credentials Link on the automation account called (say)  DSCPackageStorage as follows:

**Credential Asset**

Name: DSCPackageStorage

Username: AZURE\file-storage-name (this is the name of the storage account, prefixed by "AZURE\")

Password: Key of the file storage 

**Variable Asset**

We created the Variable Asset **DownloadPackagePath** earlier. Now in the value, enter the path to your folder where you uploaded your install files for FireEye

The following DSC Configuration copies the install files from the file share to a local c:\packages folder, using the specified credentials and the sourcePath specified in the DownloadPackagePath automation variable.

Once copied locally, the software FireEye gets installed.

```powershell
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
            DestinationPath = "C:\Packages"    
        }
        Log AfterDirectoryCopy
        {
            # The message below gets written to the Microsoft-Windows-Desired State 		Configuration/Analytic log
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
```

###Assigning the new  Configuration to  Virtual Machines

Upload and compile this configuration file as explained before,

Once the DSC configurations node says "Completed" for the configuration:

1. Go to "DSC nodes" menu
2. Click on a virtual machine
3. Click on  "Assign node configurations"
4. Select & apply the new configuration in the "Assign Node Configuration" blade

### To jump start the Configuration

The DSC will normally wait  for the time specified for the poll frequency. To immediately apply the state, on the virtual machine, run the following powershell.

```powershell
Update-DSCConfiguration
```



# Use an ARM template with a DSC extension to automatically provision a VM and register it with DSC

In the source code download, in the deployment folder, I have provided a powershell script file called CreateStorage.ps1 and an arm template called vmautomation_dsc.json. This arm template will create a virtual machine in the vnet and subnet provided as parameters.  The ARM template also includes a DSC extension resource that will automatically add the created VM to the automation DSC pull server so that it can be managed by it. To point it to the automation DSC server, we will provide the arm template with parameters that identify the DSC Server (the server key and url. We will come to it in a minute).We will wrap all this logic in a powershell RunBook.

We want to create a blob storage and upload this template to this blog. If you run the CreateStorage.ps1 powershell, it will automatically create a blob storage account and upload the arm template to it. Here are the steps to run it.

Run the deployment\CreateStorage.ps1 file  in the project. 

**It expects Parameters**

1. ResourceGroup : The resource group the automation account was created under (Step1)
2. Location: [Enter your region - example: SouthCentralUS]

**This will**:

1. Creates a blog storage account, 
2. create a container
3. Give public  access to the container
4. upload the ARM template "vmautomation_dsc.json" to the blob storage. This is the ARM template for creating the VM + associated resources. It also has the DSC extension & will register the VM as a node in the DSC server, when run later by the Run Book "DeployVm"



**Make note of the path of the  template file**

You will need to provide the path of the template file as a parameter when running Run Book DeployVM . Path will be something like: https://dccteststorage.blob.core.windows.net/abcarmtemplate/vmautomation_dsc.json

# Import Run Books in Automation Account

In the "RunBooks" tab of the automation account, click "Add a runbook" and import the following runbooks provided in the Runbooks folder of the source code provided.

1. RunDeploy.ps1 : a helper file to pass in the parameters to DeployVm.ps1

   There a number of variables passed in but the important ones are

   ```json
   $RegistrationKey : Key of the DSC automation account (found on the Keys section of the automation account)

   $RegistrationUrl: URL of the automation account, found also in the Keys section of the automation account

   $NodeConfigurationName:  The name of the DSC configuration under the "DSC nodes configuration" section. For example: CreateFileDemo.localhost if using the simple  configuration used above in the quickstart

   $TemplateFile: The full path to the arm template uploaded to the blob storage
   ```

2. DeployVm.ps1: the main file that creates the VM by calling the ARM template

3. Publish the run book DeployVm.ps1

4. Run the runbook  called  RunDeploy.ps1.  Once the VM is provisioned, you should see it appear under the DSC nodes section of the automation account and reported as "Compliant"




# Conclusion

Using Infrastructure as code to script out virtual machine creation, DSC to maintain its state, and automation to instantiate the vm provisioning is a potent combination , which can give great power to your server deployments and management