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

       
        List<string> _devicename = new List<string>() { "Pump1", "Pump2", "Pump3", "Pump4" };
        List<string> _ledColor = new List<string>() { "Red", "Yellow", "Orange", "Green" };
        
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
            data.ledColor = _ledColor[GetRandomNumber()];
         
            return JsonConvert.SerializeObject(data);
        }
    }
}
