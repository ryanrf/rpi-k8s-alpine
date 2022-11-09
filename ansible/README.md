# These ansible scripts are used to update the configs on the k3s nodes
## Usage
Update single node:
```bash
ansible-playbook -l rpi31.faircloth.ca playbook.yaml --ask-vault-pass
```

Update all nodes:
```bash
ansible-playbook playbook.yaml --ask-vault-pass
```

TODO:
- update `files/traefik_cloudflare.yaml` with real values
- in `files/traefik_cloudflare.yaml` put that in `/var/lib/rancher/k3s/server/manifests/traefik-config.yaml` (on server)
- Put cloudflare api key in ansible vault
- create secret using shell/ command (ansible) and run `kubectl create secret generic cloudflare-credentials --from-literal=globalApiKey=<YOUR API KEY>` (the secret will be available in ansible vault)
