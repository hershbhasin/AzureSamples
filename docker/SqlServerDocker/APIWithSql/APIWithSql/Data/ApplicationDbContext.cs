using System;
using APIWithSql.Models;
using Microsoft.EntityFrameworkCore;

namespace APIWithSql.Data
{
    public class ApplicationDbContext : DbContext
    {
        public DbSet<SpeakerEval> SpeakerEvaluations { get; set; }

        public ApplicationDbContext(DbContextOptions options) : base(options)
        {
            Database.EnsureCreated();
        }
    }
}
