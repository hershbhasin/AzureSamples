using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using APIWithSql.Data;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace NoDocker
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            //var connection = @"Server=db;Database=FabsEvals;User=sa;Password=P@ssword1!;";
            //var connection = @"Server=localhost\\SQLEXPRESS;Database=FabsEvals;User=sa;Password=PassW0rd";
            var connection = "Data Source=localhost\\SQLEXPRESS;Initial Catalog=FabsEvals;Integrated Security=true";

            services.AddDbContext<ApplicationDbContext>( options => options.UseSqlServer(connection));
            //services.AddScoped<iSpeakerEvalsRepository, SpeakerEvalsRepository>();
            services.AddMvc();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env,  ILoggerFactory loggerFactory, ApplicationDbContext evalDataContext)
        {
            loggerFactory.AddConsole(Configuration.GetSection("Logging"));
            loggerFactory.AddDebug();

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            //uses to seed the SQLCore Database in the Docker Container
            evalDataContext.EnsureSeedDataForContext();

            app.UseMvc();
        }
    }
}
