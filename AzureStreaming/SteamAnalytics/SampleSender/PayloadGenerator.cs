using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Text;
using Newtonsoft.Json;

namespace SampleSender
{
    public class PayloadGenerator
    {
        private static readonly Random Getrandom = new Random();

        List<string> _users = new List<string>(){ "Bob", "John", "Sue", "Tom" };
        List<string> _actions = new List<string>() { "Get", "Set", "Add", "Delete" };
        List<string> _devicename = new List<string>() { "Acendo Book 123", "Acendo Core xyz", "CT Series qxt", "Acendo Core 456" };
        List<string> _projects = new List<string>() { "Newton", "Nelson Mandala", "Scott Miller", "Richardson" };
        List<string> _tenants = new List<string>() { "Disney", "Multi Vision", "ABC Integrators", "Sound Labs" };
        public static int GetRandomNumber()
        {
            lock (Getrandom) // synchronize
            {
                return Getrandom.Next(1, 4);
            }
        }

        public string Payload()
        {
            dynamic data = new ExpandoObject();
            data.device = _devicename[GetRandomNumber()];
            data.username = _users[GetRandomNumber()];
            data.action = _actions[GetRandomNumber()];
            data.project = _projects[GetRandomNumber()];
            data.tenant = _tenants[GetRandomNumber()];

            return JsonConvert.SerializeObject(data);
        }
    }
}
