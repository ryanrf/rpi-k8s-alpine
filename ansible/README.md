# These ansible scripts are used to update the configs on the k3s nodes
## Usage
Update single node:
```bash
ansible-playbook -l rpi41.faircloth.ca main.yaml
```

Update all nodes:
```bash
ansible-playbook main.yaml --ask-vault-pass
```

Upgrade image on a single node (recommended one at a time):
```
ansible-playbook --extra-vars "upgrade=true" -l rpi41.faircloth.ca main.yaml
```

Upgarde image on all nodes:
```
ansible-playbook --extra-vars "upgrade=true" main.yaml
```

## Additional k8s manifests
To install any additional k8s manifests, just put them in the `k8s/` directory and run the `provision.yaml` file (with the above command).

## TODO:
* copy certificates to encrypted variables - the token is based on a hash of the CA certificate, so copying just the token isn't enough for a new cluster. This is only important if setting up a new cluster.
