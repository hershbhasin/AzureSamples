﻿FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY APIWithSql/APIWithSql.csproj APIWithSql/
RUN dotnet restore APIWithSql/APIWithSql.csproj
COPY . .
WORKDIR /src/APIWithSql
RUN dotnet build APIWithSql.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish APIWithSql.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
#ENTRYPOINT ["dotnet", "APIWithSql.dll"]
RUN chmod +x ./entrypoint.sh
CMD /bin/bash ./entrypoint.sh