using kv.util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using Microsoft.Azure.KeyVault;
using System.Web.Configuration;

namespace kv
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            var kv = new KeyVaultClient(new KeyVaultClient.AuthenticationCallback(KeyVaultHelper.GetToken));
            //connectionString is the url to key vault
            var task = kv.GetSecretAsync(WebConfigurationManager.AppSettings["connectionString"]);
            task.Wait();

            //get the stored conn string
            KeyVaultHelper.connectionStringSecret = task.Result.Value;
           
        }
    }
}
