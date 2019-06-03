Middleware

Added in Configure method in Startup.cs

https://docs.microsoft.com/en-us/aspnet/core/fundamentals/middleware?tabs=aspnetcore2x

Querying a XML appsettings
```c#
app.Use(async (context, next) =>
        {
            // Do work that doesn't write to the Response.
            await next.Invoke();
            // Do logging or other work that doesn't write to the Response.
        });
```



**Adding Middleware:**

In configure method, first middleware should be the following, which allows capturing of errors

```c#
if (env.IsDevelopment())
      {
        app.UseDeveloperExceptionPage();
      }
```



Requires a Invoke method to be implemented 

```c#
 app.UseMiddleware<LoggingMiddleware>();
```

**Map & MapWhen**

Like legacy handlers, associated with a specific path, file type or both

# DI

IServiceCollection Methods

AddTransiant<interface, type> : new object every time

AddScoped: new object, every request

AddSingleton: same object

**Switching DI Provider**

Implement IServiceProvider

# Application Settings

**Legacy:** 

web.config / System.Configuration/ ConfigurationManager

**Dotnet Core** : Microsoft.Extensions.Configuration (nugget package. Use appropriate xml, json, ini etc. Example: Microsoft.Extensions.Configuration.Json)

Nugets:

Microsoft.Extensions.Configuration.Json

Microsoft.Extensions.Options.ConfigureExtensions

injected as dependency

```json
{
	‘appSettings’ : {
	‘UniqueKey’: ‘123-456-789’
	}
}
```



```c#
var builder = new ConfigurationBuilder();

/*Sources are combined,
inspected in reverse order for
values; allows for overrides
*/
builder.AddJsonFile(“appsettings.json”)
.AddJsonFile(“appsettings.dev.json”)
.AddCommandLine(args);

/*
Generates a uniform
IConfiguration object regardless
of sources
*/
var config = builder.Build();

Write (config[“AppSettings:UniqueKey”])
//outputs ”123-456-789”
```

Pull in the IHostingEnvironment to get at path of appsettings file.

```c#
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;

private IConfiguration _configuration;
public Startup(IHostingEnvironment env)
    {
      var builder = new ConfigurationBuilder();
      builder.SetBasePath(env.ContentRootPath)
        .AddXmlFile("appsettings.xml")
        .AddJsonFile("appsettings.json");
      _configuration = builder.Build();
    }
```
Querying a XML source

```xml
<configuration>

  <connectionStrings>
    <add name="user" connectionString="Data Source=something" providerName="System.Data.SqlClient"/>
  </connectionStrings>
</configuration>
```



```c#
var connStr = _configuration["ConnectionStrings:Add:User:ConnectionString"]
```

Querying Json with options

```json
{
  "passwords": {
    "AdminPassword": "Password1!",
    "DefaultPassword":  "Default" 
  }
}
```

Passwords Class

```c#
 public class Passwords
    {
      public string AdminPassword { get; set; }
      public string DefaultPassword { get; set; }
    }
```



Reference Options. Now whenever IOptions<Passwords> is requested, this will be returned

```c#
public void ConfigureServices(IServiceCollection services)
 {
   services.AddOptions();
   services.Configure<Passwords>(
    _configuration.GetSection("passwords"));
 }
```

Usage

```c#
 public AuthenticationMiddleware(RequestDelegate next,
      UserContext context, IOptions<Passwords> passwords)
    {
      
      var adminPassword = passwords.Value.AdminPassword;
    }
```



# Request & Response

https://docs.microsoft.com/en-us/aspnet/core/migration/http-modules#migrating-to-the-new-

Legacy: System.Web.HttpContext

Core: Microsoft.AspNetCore.Http.HttpContext