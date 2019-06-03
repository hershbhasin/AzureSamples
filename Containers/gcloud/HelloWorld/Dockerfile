
FROM microsoft/dotnet:1.1.0-runtime
COPY . /app
WORKDIR /app
EXPOSE 8080/tcp
ENV ASPNETCORE_URLS http://*:8080
ENTRYPOINT ["dotnet", "HelloWorld.dll"]