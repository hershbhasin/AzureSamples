https://docs.microsoft.com/en-us/vsts/build-release/apps/aspnet/build-aspnet-core?tabs=vsts

https://docs.microsoft.com/en-us/vsts/build-release/apps/cd/deploy-webdeploy-iis-deploygroups

### Deployment Group

A deployment group is a logical set of deployment target machines that have agents installed on each one. Deployment groups represent the physical environments; for example, "Dev", "Test", "UAT", and "Production". In effect, a deployment group is just another grouping of agents, much like an [agent pool](https://docs.microsoft.com/en-us/vsts/build-release/concepts/agents/pools-queues).



The script that you've copied to your clipboard will download and configure an agent on the VM so that it can receive new web deployment packages and apply them to IIS.