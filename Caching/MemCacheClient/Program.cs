using Enyim.Caching;
using Enyim.Caching.Configuration;
using Enyim.Caching.Memcached;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MemCacheClient
{
    class Program
    {
        static void Main(string[] args)
        {
            MemcachedClientConfiguration configuration = new MemcachedClientConfiguration();
            configuration.AddServer("127.0.0.1:11211");
            MemcachedClient client = new MemcachedClient(configuration);

            client.Store(StoreMode.Set, "Test", "Hello World");

            var s = client.Get("Test");
        }
    }
}
