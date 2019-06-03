using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(kv.Startup))]
namespace kv
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
