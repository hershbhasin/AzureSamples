ap-get update

#install npm
apt-get install npm

#install cli
npm install -g azure-cli

#file linking
ln -s /usr/bin/nodejs /usr/bin/node

#azure cli should be working
azure

#install python utlity pip
apt install python-pip

#install python/azure sdk
pip install --pre azure

#upgrade
pip install --upgrade pip

#some more
curl -L https://aka.ms/InstallAzureCli |bash

source ~/.bashrc

#ready to test
az acs -h

#vm sizes
az vm list-sizes -l "eastus2"
#---------------Create Kubernetes-------------#

#login
az login

#Rg
RESOURCE_GROUP_NAME=hbResourceGroup4
CLUSTER_NAME=hbK8sCluster4

#Create Resource Group
az group create --name $RESOURCE_GROUP_NAME --location "westus2"

#Create: 

#az aks create --resource-group $RESOURCE_GROUP_NAME --name $CLUSTER_NAME --agent-count 1 --generate-ssh-keys

az acs create --orchestrator-type kubernetes --resource-group $RESOURCE_GROUP_NAME --name $CLUSTER_NAME \
--master-count 1 --master-vm-size Standard_A0 --agent-count 1  --agent-vm-size Standard_A0 --generate-ssh-keys

#download credentials

az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $CLUSTER_NAME

az aks get-credentials --resource-group hbResourceGroup2 --name hbK8sCluster2

#this does not work  so do next step
az aks get-versions --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP_NAME
 
#get DNS name of Master VM
mkdir $HOME/.kube
scp azureuser@hbk8sclust-hbresourcegroup2-c42d5bmgmt.eastus.cloudapp.azure.com:.kube/config $HOME/.kube/config       

#install kubectrl
sudo snap install kubectl --classic   