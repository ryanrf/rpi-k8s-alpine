## Installing Cert Manager

Run:
```shell
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml
```

For Cloudflare tokens can be created at User Profile > API Tokens > API Tokens. The following settings are recommended:

Permissions:
Zone - DNS - Edit
Zone - Zone - Read

Zone Resources:
Include - All Zones

Create a secret (in `cert-manager` namespace) called cloudflare-api-token-secret:
```shell
kubectl -n cert-manager create secret generic cloudflare-api-token-secret --from-literal=api-token=<api token>
```

Create ClusterIssuer for issuing certificates:
```shell
kubectl apply -f ClusterIssuer.yaml
```
