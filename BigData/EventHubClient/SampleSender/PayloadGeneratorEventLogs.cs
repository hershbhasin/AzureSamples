using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Text;
using Newtonsoft.Json;

namespace SampleSender
{
    public class PayloadGeneratorEventLogs
    {
        private static readonly Random Getrandom = new Random();

        List<string> _category = new List<string>(){ "DSP", "Application", "Network", "HControl" };
        List<string> _priority = new List<string>() { "Debug", "Information", "Warning", "Error " };
        List<string> _message = new List<string>() { "Exceeded available concurrent connections for account", "Exceeded subscriptions for account", "Server can not service this request right now", "Login Timeout" };
        List<string> _devicename = new List<string>() { "Acendo Book 2107", "Acendo Core 5100", "CT Series 1301", "Room Book 1001" };
        List<string> _projects = new List<string>() { "Newton", "Nelson Mandala", "Scott Miller", "Richardson" };
        List<string> _tenants = new List<string>() { "Disney", "Multi Vision", "ABC Integrators", "Sound Labs" };

        private DateTime timestamp;
        public PayloadGeneratorEventLogs()
        {
            string iDate = "01/12/2018";
            timestamp = Convert.ToDateTime(iDate);
           
        }
        public static int GetRandomNumber()
        {
            lock (Getrandom) // synchronize
            {
                return Getrandom.Next(1, 4);
            }
        }

        public string Payload()
        {
            timestamp = timestamp.AddMinutes(5);
            dynamic data = new ExpandoObject();
            data.timestamp = timestamp;
            data.device = _devicename[GetRandomNumber()];
            data.category = _category[GetRandomNumber()];
            data.priority = _priority[GetRandomNumber()];
            data.message = _message[GetRandomNumber()];
            data.project = _projects[GetRandomNumber()];
            data.tenant = _tenants[GetRandomNumber()];

            return JsonConvert.SerializeObject(data);
        }
    }
}
