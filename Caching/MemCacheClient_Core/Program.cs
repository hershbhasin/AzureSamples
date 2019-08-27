
using Enyim.Caching.Memcached;
using System;
using System.Threading.Tasks;

namespace MemCacheClient
{
    class Program
    {
        static async Task Main(string[] args)
        {
            // connect to a list of memcached servers
            var cluster = new MemcachedCluster("localhost,localhost:11212,localhost:11213");
            // this is mandatory
            cluster.Start();

            var client = cluster.GetClient();
            await client.SetAsync("hello", new { hello = "world" });

            // more work

            // stop the cluster
            cluster.Dispose();
        }
    }
}
