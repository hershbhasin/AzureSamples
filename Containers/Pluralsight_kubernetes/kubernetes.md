# Azure

Install Azure CLI : https://docs.microsoft.com/en-us/cli/azure/overview?view=azure-cli-latest

### Minikube

Install instructions : https://kubernetes.io/docs/tasks/tools/install-minikube/

You should have virtual box installed

put in path: kubectl.exe & minikybe.exe

The following command creates a vm in Virtual Box. 1 master & 1 node

```bash
#start
minikube start

#nodes
kubectl get nodes

#dashboard
minikube dashboard
```

#Master & Nodes

###Master

**Kube-apiserver** : front end to the control plane, exposes the API, resides on master. We send it the manifest yml file & master deploys services to cluster. The only service we deal directly with.

**Cluster Store**: persistent storage. config and state of cluster gets stored here. Uses etcd (open source key-value store, developed by core os)

kube-controller-manager: controller of controllers: node controller, endpoints controller, namespace controller... watch for changes and help maintain desired state.

**kube-scheduler**: watches apiserver for new pods, assigns works to nodes

### Nodes

**Kubelet**: the main kubernetes agent on the node. It registers node with cluster and then watches apiserver for work assignments. It carries out the task (instantiates pod), then reports back to master. It exposes an endpoint on port 10255 where you can inspect it. Some API calls: /spec, /healthz, /pods

*(definition) pod*: one or more containers packaged together and deployed as a unit.

**Container engine**: works with pods. pulls images, start/stops containers. Container runtime is usually Docker - it uses native Docker API

**Kube-proxy**: Kubernetes networking. Responsible for assigning one unique ip to all containers in a pod. Does lightweight load balancing across all pods in a service.

*(definition) Service*: is a way of hiding multiple pods behind a single network address.

### Labels

The way a pod belongs to a service is via labels. If we label the service and a pod with the same labels, the service will load balance it.

This is great for versioning. If we add a version number, service will automatically target the matching version number. If something bad happen to the new version, we can simply go back to earlier version by flipping the label.

# Deployments

Deployments wrap around Replication Controllers. Deployments  manage updates and rollbacks. In the world of deployments, Replication Controllers, with subtle differences,  are Replica Sets. Deployments manage Replica Sets and Replica Sets manage Pods.

You deploy with a YAML file, K8s creates a Replica set. You need to update, you modify the YAML file and give to the apiserver again. K8s creates a new Replica set and once it is provisioned, removes the old Replica Set. The old Replica Sets don't get deleted. They stick around if you want to rollback.

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hello-deploy
spec:
  replicas: 10
  minReadySeconds: 10
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-pod
        image: nigelpoulton/pluralsight-docker-ci:latest
        ports:
        - containerPort: 8080
```

```bash
#create
kubectl create -f deploy.yml

#describe
kubectl describe deploy hello-deploy

#rs replica set
kubectl get rs

#describe
kubectl describe rs

#delete
kubectl delete deploy hello-deploy
```

### Load Balancer

```bash
#Expose Load balancer
kubectl expose deployment hello-deploy --type="LoadBalancer"

#hit it in browser
#this will show you the external ip of the loadbalancer and Ports i.g 8080:32532 TCP. First is the external port. Browse to externalIP:port

kubectl get services




```



**Updates**

minReadySeconds: sec to wait before updating next

```bash
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hello-deploy
spec:
  replicas: 10
  minReadySeconds: 10
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-pod
        image: nigelpoulton/pluralsight-docker-ci:latest
        ports:
        - containerPort: 8080
```

```bash
#apply update: always use record because it gives user friendy label to hist
kubectl apply -f deploy.yml --record

#watch
kubectl rollout status deployment hello-deploy

#get
kubectl get deploy hello-deploy

#history: will show versions/revisions
kubectl rollout history deployment hello-deploy

#rs
kubectl get rc

#describe current state of deployment
kubectl describe deploy hello-deploy
```



### Rollback

```bash
#rollback
kubectrl rollout undo deployment hello-deploy --to-revision=1

#watch
kubectl get deploy

#status
kubectl rollout status  deployment hello-deploy
```



