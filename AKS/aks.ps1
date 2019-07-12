$rg = "rg-acs"
$location = "eastus"

#acs

$repoName = "mywonderfulrepo1"
$loginServerName = $repoName + ".azurecr.io"
$imageName = "letskube"
$localImageName = $imageName + ":local" 
$taggedImageName = $loginServerName + "/" + $imageName + ":v1"
$taggedImageNameVer2 = $loginServerName + "/" + $imageName + ":v2"

#aks
$clusterName = "myAKSCluster"

#service principal
$appid = "a3a36304-90d7-4ffe-9385-263df5552d29"
$password = "28a65f40-20d9-40ba-b6d8-69b0126aea3e"


 cd C:\_hbGit\AzureSamples\AKS\letskube

############ Docker: create image ############


docker build -t $localImageName .

#check local image
docker image list | select -First 2

docker run -d  -p 5000:80 $localImageName


############login############
#az login
az login --use-device-code
az account set --subscription "Visual Studio Professional"



############resource group############
az group create -n $rg -l $location


############ Create Azure Container Registry (ACR)############

az acr create -n $repoName -g $rg -l $location --sku standard

#check
az acr list -o table



#login to acr
az acr login -n $repoName

#you have to tag the image with the login server name. To get the name run
az acr list -o table

#tag image
docker tag letskube:local  $taggedImageName
docker image list




############ Push ############ 
# In Repo, under Access Keys, enable Admin User and note the username & password
#login to acr
#for some reason az acr login does not work, hence using workarount
#https://docs.microsoft.com/en-gb/azure/container-registry/container-registry-authentication#admin-account

#docker login $loginServerName -u "myWonderfulRepo" -p "akC65KxasD+XpQZUd/lXszBC+SNk/Wi9"

##Important Note: I had lots of authentication problem with the ACS repo created with cli
##I recreated the ACS repo from the portal and then authentication from cli 
#and also with Service principal credentials worked
#like thus: az acr login -n myWonderfulRepo1 -u "a3a36304-90d7-4ffe-9385-263df5552d29" -p "28a65f40-20d9-40ba-b6d8-69b0126aea3e"

az acr login --name $repoName

docker push  $taggedImageName

#view repo images
az acr repository list -n mytestacr12345 -o table

############ Give Service Principal rights to ACS ############ 
#skip-assignmen will limit any additional permissions from being assigned
#default behaviour is contributor role, which is too broad
az ad sp create-for-rbac --skip-assignment

#note the appid & password

#get the acr resource id by running following:
$acrId = az acr show --name $repoName --resource-group $rg --query "id" --output tsv
$acrId

#assign reader role to aks cluster to read images stored in acr
az role assignment create --assignee $appid --role Reader --scope $acrId




#create aks cluster

az aks create `
--name $clusterName `
--resource-group $rg `
--node-count 1 `
--enable-addons monitoring `
--generate-ssh-keys `
--service-principal $appid `
--client-secret $password

#connect
az aks get-credentials --resource-group $rg --name $clusterName



# Deploy

#Ensure that the deployment yml image is correctly tagged with server name
# to get login server
#az acr list --resource-group $rg --query "[].{acrLoginServer:loginServer}" --output table

kubectl apply -f .\letskubedeploy.yml

# watch till you get external ip. ctrl-c to quit
kubectl get service --watch

#az provider register --namespace "Microsoft.OperationsManagement"

kubectl get service


############Scale#######################
#connect
az aks get-credentials --resource-group $rg --name $clusterName

kubectl get nodes

#scale nodes: will add mode virtual machines
az aks scale --resource-group $rg --name=$clusterName --node-count 3

kubectl get pods

#scale pods
kubectl get deployment
kubectl scale --replicas=1 deployment/letskube-deployment

kubectl get pods

############Update the Image#################

#make some change in app and then build:
docker build . -t $taggedImageNameVer2


az acr login --name $repoName

docker push  $taggedImageNameVer2

#now you can change the image name in the deployment.yml file and redeploy or use cli like thus:
#lutskube is the app name we specified in deployment.yml earlier

kubectl set image deployment letskube-deployment letskube=mywonderfulrepo1.azurecr.io/letskube:v2

#########Browse

az aks browse -g $rg -n $clusterName


##############Helpers#############
#delete all containers
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

docker ps -a

#delete all images
docker rmi $(docker images -q) --force