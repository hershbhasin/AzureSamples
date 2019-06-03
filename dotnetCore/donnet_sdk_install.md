# Install the .NET Core SDK
```c#
# Install the .NET Core SDK
Invoke-WebRequest https://go.microsoft.com/fwlink/?linkid=848827 -outfile $env:temp\dotnet-dev-win-x64.1.0.4.exe
Start-Process $env:temp\dotnet-dev-win-x64.1.0.4.exe -ArgumentList '/quiet' -Wait
```

