# k8s dashboard

## Install/ Update
[`dashboard.yaml`](./dashboard.yaml) was grabbed from [https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml](https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml)

## Token

A user token is required to authenticate to the k8s dashboard. The token is created
```shell
kubectl -n kubernetes-dashboard create token admin-user
```

The token is retrieved using:
```shell
kubectl -n kubernetes-dashboard get secrets/<name of admin token> -o yaml | yq '.data.token' | base64 -d
```

## Access Dashboard

To access the dashboard:
```shell
kubectl proxy
```
> To set up the proxy to the k8s API

Grab the token with:
```shell
kubectl -n kubernetes-dashboard get secrets/admin-user-token-gbv2k -o yaml | yq -r '.data.token' | base64 -d
```

To access the dashboard go to: [http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/workloads?namespace=_all](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/workloads?namespace=_all)
