#https://carlos.mendible.com/2017/12/01/deploy-your-first-service-to-azure-container-services-aks/
#eastus,westeurope,centralus,canadacentral,canadaeast

################################################################
# Login
################################################################

az login -u hersh.bhasin@harman.com -p Harman@123

az account set --subscription ce644727-f6f9-4d03-a4bb-f687d3eaf60d

################################################################
# RG
################################################################

az group create -l eastus -n aks


################################################################
# Create an Azure Container Registry:
################################################################

az acr create -g aks -n hbk8reg --sku Basic --admin-enabled

################################################################
# Login to Azure Container Registry
################################################################
az acr login -n hbk8reg

################################################################
# Test Locally
################################################################
# maps local web server at 8081: to docker image at 80
# will runs at http://localhost:8081/

docker run -d --name web -p 8081:80 yaros1av/hello-core

docker start web
docker stop web


################################################################
# Push an image to the Azure Container Registry
################################################################

docker pull yaros1av/hello-core

docker tag yaros1av/hello-core hbk8reg.azurecr.io/hello-core:1.0

docker push hbk8reg.azurecr.io/hello-core:1.0

################################################################
# Create AKS cluster
################################################################
<#
Register-AzureRmResourceProvider -ProviderNamespace "Microsoft.Compute"
Register-AzureRmResourceProvider -ProviderNamespace "Microsoft.Storage"
Register-AzureRmResourceProvider -ProviderNamespace "Microsoft.Network"
#>

az aks create -g aks --name myAKSCluster --generate-ssh-keys