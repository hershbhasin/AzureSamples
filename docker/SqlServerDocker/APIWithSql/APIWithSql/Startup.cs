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


namespace APIWithSql
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
            // we are defining the Connection String, the “db” you see in the ‘Server=’ needs to be mapped to exactly what you have 
            //in the “Docker-Compose.yml” file, which is where you define the ‘Services’ that Docker will be creating for you 
            //[Services is analogous to Containers]

            //var connection = @"Server=db;Database=FabsEvals;User=sa;Password=PassW0rd;";
            //SQL Server
            var connection = Configuration["ConnectionString"];
            services.AddDbContext<ApplicationDbContext>(options => options.UseSqlServer(connection));
            
            services.AddScoped<iSpeakerEvalsRepository, SpeakerEvalsRepository>();

            //Swagger
            services.AddSwaggerGen(options =>
            {
                options.DescribeAllEnumsAsStrings();
                options.SwaggerDoc("v1", new Swashbuckle.AspNetCore.Swagger.Info
                {
                    Title = "APIWithSqlServer - Catalog HTTP API",
                    Version = "v1",
                    Description = "The  Microservice HTTP API. This is a Data-Driven/CRUD microservice sample",
                    TermsOfService = "Terms Of Service"
                });
            });


            services.AddMvc();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory, ApplicationDbContext evalDataContext)
        {
            loggerFactory.AddConsole(Configuration.GetSection("Logging"));
            loggerFactory.AddDebug();

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            //uses to seed the SQLCore Database in the Docker Container
            evalDataContext.EnsureSeedDataForContext();


            //swagger
            app.UseSwagger()
           .UseSwaggerUI(c =>
           {
               c.SwaggerEndpoint("/swagger/v1/swagger.json", "My API V1");
           });


            app.UseMvc();
        }
    }
}
