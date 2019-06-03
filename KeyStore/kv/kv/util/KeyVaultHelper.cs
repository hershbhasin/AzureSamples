using Microsoft.IdentityModel.Clients.ActiveDirectory;
using System;
using System.Threading.Tasks;
using System.Web.Configuration;
namespace kv.util
{
    public class KeyVaultHelper
    {
        public static string connectionStringSecret { get; set; }
        public static async Task<string> GetToken(string authority, string resource, string scope)
        {
            //acquire a token from application providing its client id and client secret
            var authContext = new AuthenticationContext(authority);
            ClientCredential clientCred = new ClientCredential(WebConfigurationManager.AppSettings["ClientId"],
                        WebConfigurationManager.AppSettings["ClientSecret"]);
            AuthenticationResult result = await authContext.AcquireTokenAsync(resource, clientCred);

            if (result == null)
                throw new InvalidOperationException("Failed to obtain the JWT token");

            return result.AccessToken;
        }
    }
}