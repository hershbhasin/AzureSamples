# Exposing Services & Replica Sets

I Think this is outdated. You should expose a Load Balance and use a deployment set in GCloud

### Pods

A sandboxed environment for a container. All containers must reside in pods. Unit of scaling is also a pod: you don't scale by adding more containers but by replicating pods. Pods exist on a single node. Deployed by manifest files and the Replication Controller. Note: We don't really work with pods this way. We work with a Replication Controller , where we specify a "desired state" of the replicas and it keeps state of the cluster from drifting from this state

```yaml
#sample pod manifest
apiVersion: v1
kind: Pod
metadata:
  name: hello-pod
  labels:
    zone: prod
    version: v1
spec:
  containers:
  - name: hello-ctr
    image: nigelpoulton/pluralsight-docker-ci:latest
    ports:
    - containerPort: 8080

```

```bash
#create pod
kubectl create -f pod.yml

#check
kubectl get pods
kubectl get pods/hello-pod

#describe
kubectl describe pods

#delete
kubectl delete pods hello-pod
```

### Replication Controller

```yaml
## Sample Replication Controller YAML file used in example (called rc.yml in video):
apiVersion: v1
kind: ReplicationController
metadata:
  name: hello-rc
spec:
  replicas: 10
  selector:
    app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-ctr
        image: nigelpoulton/pluralsight-docker-ci:latest
        ports:
        - containerPort: 8080
```

```bash
#create rc
kubectl create -f rc.yml

#check
kubectl get rc
kubectl get rc -o wide

#describe
kubectl describe rc

#delete rc
kubectl delete svc hello-svc

```

**Updating YAML**

after making changes

```baxh
kubectl apply -f pods.yml

```





###Services

Pods die and come up with new IPs. We can scale the up and down and they get new IPs. We cannot rely on pod IPs. A Service object is Kubernetes object, defined with a YAML manifest. It provides a stable IP and DNS name & load balancing for pods. By default DNS name is same as the service name.

Outside: by service  ip & port : An endpoint object is created (like a lb pool)

pod to pod (internal): localhost

You tie the service & pods together by labels. In the Replication Controller manifest above, the label we gave was "hello-world"

**Iterative way of exposing services**

```bash
#create service
kubectl expose rc hello-rc --name=hello-svc --target-port=8080 --type=NodePort


#describe
kubectl describe svc hello-svc

#note the NodePort. In my case it was 32319
#We can hit any node in the cluster at this port to get to our service

#Get the Nodes/External ID from dashboard. If running on minikube, it is minikube

#dashboard
minikube dashboard

#view web page at NodePort 
http://minikube:32319/

#delete svc
kubectl delete svc hello-svc
```

**Declarative  way of exposing service (YAML File): the preferred way**

Type:

Each step below adds a wrapper on top of ClusterIP

1. ClusterIP : Stable internal cluster IP
2. NodePort: Exposes the app outside of the cluster by adding a cluster-wide port on top of ClusterIP
3. LoadBalancer: Integrates NodePort with cloud-based load balancers.

Below, pods internally expose 8080 and externally, the node exposes port 30001.

Selector has to match selector in Replication Controller.

Labels tie service to replication controller, hence should match.

```yaml
### The following is the "svc.yml" file used in the module
apiVersion: v1
kind: Service
metadata:
  name: hello-svc
  labels:
    app: hello-world
spec:
  type: NodePort
  ports:
  - port: 8080
    nodePort: 30001
    protocol: TCP
  selector:
    app: hello-world
```



```bash
#check if rc selecter matches
kubectl describe pods |grep app

#create
kubectl create -f svc.yml
#check
kubectl describe svc hello-svc
```

**Endpoints**

These are the endpoints of all pods the service manages

```grep
kubectl get ep
kubectl describe ep hello-svc
```

