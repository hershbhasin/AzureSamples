#https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough

<#
#login
az login



#Enable AKS Preview in you subscription
az provider register -n Microsoft.ContainerService

#check status
az provider show -n Microsoft.ContainerService

#Create a resource group
az group create --name myResourceGroup1 --location westus2

#create aks cluster
az aks create --resource-group k8swestus2 --name myK8sCluster --agent-count 1 --generate-ssh-keys --debug

#>

az group create --location westus2 --name k8swestus2

az aks create --resource-group k8swestus2 --name myK8sCluster --agent-count 1 --generate-ssh-keys --debug