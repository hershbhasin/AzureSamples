

https://github.com/g0t4/pluralsight-aspdotnet-core-msbuild-tooling

```bash
#list templates
dotnet new -h

#o = new dir 
dotnet new web -o myweb  

#-n = namespace n will create a new folder so down't use o;  or use o . which means use current folder
dotnet new web -o . -n customns

#powershell tree
tree /f

#restore dependencies
dotnet restore

#run
dotnet run

#Edit the project file in visual studio
#rtclick project and select edit
```

```bash
#webapi
dotnet new webapi -o mywebapi

dotnet restore; dotnet run;

#localhost
http://localhost:61933/api/values
```

MVC

```bash
dotnet new mvc -o mymvc
cd mymvc
dotnet restore; dotnet run;

```



**Adding packages**

packages are added in .csproj with a <PackageReference> tag. Tight integration between VS and csproj. Removing reference from outside VS, causes VS to Refresh

```bash
  <PackageReference Include="Microsoft.AspNetCore.All" Version="2.0.0" />
```



 **Intellisence  in .csproj**

In Tools/extensions & Updates, install Project File Tools

### Dotnet sdk

```bash
#find path
which dotnet
```



# Projects & Solutions

