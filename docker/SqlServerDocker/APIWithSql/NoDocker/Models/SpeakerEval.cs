using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace APIWithSql.Models
{
    public class SpeakerEval
    {

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id
        {
            get;
            set;
        }

        public string SessionName
        {
            get;
            set;
        }

        public string SessionNumber
        {
            get;
            set;
        }

        public string SpeakerName
        {
            get;
            set;
        }

        public double SessionScore
        {
            get;
            set;
        }

        public string SessionEvalNotes
        {
            get;
            set;
        }

        public bool ParticipateInRaffle
        {
            get;
            set;
        }

        public string AttendeeName
        {
            get;
            set;
        }

        public string AttendeeEmail
        {
            get;
            set;
        }

        public string AttendeePhoneNumber
        {
            get;
            set;
        }

        public ICollection<SpeakerEval> SpeakerEvalsCollection { get; set; }
        = new List<SpeakerEval>();

    }
}
