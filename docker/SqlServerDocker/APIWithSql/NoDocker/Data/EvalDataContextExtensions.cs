using APIWithSql.Models;
using System;
using System.Collections.Generic;
using System.Linq;
namespace APIWithSql.Data
{
    public static class EvalDataContextExtensions
    {
        public static void EnsureSeedDataForContext(this ApplicationDbContext context)
        {
            if (context.SpeakerEvaluations.Any())
            {
                return;
            }

            var mEvals = new List<SpeakerEval>()
            {
                new SpeakerEval()
                {
                SessionName = "Whats new in SharePoint 2016 Hybrid",
                SessionNumber = "FGW123",
                SessionScore = 4,
                SessionEvalNotes = "Session was good. Loved it",
                SpeakerName = "Fabian Williams",
                ParticipateInRaffle = true,
                AttendeeName = "John Snow",
                AttendeeEmail = "js@hbo.com",
                AttendeePhoneNumber = "202-555-1234"
                },

                new SpeakerEval()
                {
                SessionName = "Xamarin Forms Deep Dive",
                SessionNumber = "FGW321",
                SessionScore = 4,
                SessionEvalNotes = "Great examples and good Lab Demos",
                SpeakerName = "Fabian Williams",
                ParticipateInRaffle = false,
                AttendeeName = "",
                AttendeeEmail = "",
                AttendeePhoneNumber = ""
                },

                new SpeakerEval()
                {
                SessionName = "Docker for SharePoint Devs",
                SessionNumber = "FGW231",
                SessionScore = 5,
                SessionEvalNotes = "Session was good. Loved it",
                SpeakerName = "Fabian Williams",
                ParticipateInRaffle = true,
                AttendeeName = "Little Finger",
                AttendeeEmail = "lf@hbo.com",
                AttendeePhoneNumber = "301-555-1287"
                }

            };

            context.SpeakerEvaluations.AddRange(mEvals);
            context.SaveChanges();


        }
    }
}
