using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Text;
using Newtonsoft.Json;

namespace SampleSender
{
    public class PayloadGeneratorQOS
    {
        private static readonly Random Getrandom = new Random();

        private static DateTime timestamp = DateTime.Now;

        
        List<string> _status = new List<string>() { "u", "d" };
        List<string> _devicename = new List<string>() { "Book 123", "Core xyz" };
       
        public static int GetRandomNumber()
        {
            lock (Getrandom) // synchronize
            {
                return Getrandom.Next(1, 2);
            }
        }

        public string Payload()
        {
            timestamp = timestamp.AddMinutes(5);
            dynamic data = new ExpandoObject();
            data.timestamp = timestamp;
            data.device = _devicename[GetRandomNumber()];
            data.status = _status[GetRandomNumber()];
            data.minutes = 5;
            

            return JsonConvert.SerializeObject(data);
        }
    }
}
