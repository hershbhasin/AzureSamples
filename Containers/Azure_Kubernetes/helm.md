Download helm & put it  path & run helm init: This creates a pod called tiller in your cluster. Helm is client, Tiller the server. Release = Chart (pre-defined image) + values (user config). Chart is a package.



```bash
#init
helm init

#check: you should see tiller
kubectl get pods --namespace=kube-system

#search for a chart to install
helm search wordpress
```



