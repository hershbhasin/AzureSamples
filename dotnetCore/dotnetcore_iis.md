

### Preparing the VM

https://docs.microsoft.com/en-us/vsts/build-release/apps/cd/deploy-webdeploy-iis-deploygroups

```bash
# Install IIS
Install-WindowsFeature Web-Server,Web-Asp-Net45,NET-Framework-Features

# Install the .NET Core SDK
Invoke-WebRequest https://go.microsoft.com/fwlink/?linkid=848827 -outfile $env:temp\dotnet-dev-win-x64.1.0.4.exe
Start-Process $env:temp\dotnet-dev-win-x64.1.0.4.exe -ArgumentList '/quiet' -Wait

# Install the .NET Core Windows Server Hosting bundle
Invoke-WebRequest https://go.microsoft.com/fwlink/?LinkId=817246 -outfile $env:temp\DotNetCore.WindowsHosting.exe
Start-Process $env:temp\DotNetCore.WindowsHosting.exe -ArgumentList '/quiet' -Wait

# Restart the web server so that system PATH updates take effect
net stop was /y
net start w3svc
```



**Enable IIS Management Tools**

1. Server Manager
2. IIS/Manage/ Add Roles & Features (Top Nav bar on RHS)
3. Next. Next, Next till you get to server Roles
4. Enable Management Tools under IIS section



Now in search bar search for Windows Administrative Tools and you will see IIS



### References

https://docs.microsoft.com/en-us/vsts/build-release/apps/cd/deploy-webdeploy-iis-deploygroups

https://weblog.west-wind.com/posts/2016/Jun/06/Publishing-and-Running-ASPNET-Core-Applications-with-IIS



