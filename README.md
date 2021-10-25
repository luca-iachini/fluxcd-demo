# fluxcd-test

fluxcd test repo

## Install

Execute all the scripts in te fluxcd folder:

- `1-docker-registry.sh` add a local registry
- `2-install-flux.sh` add flux controllers to kubernetes
- `3-dev-env-init.sh` configure the dev env to deploy a test app.

## Useful commands

Get fluxcd git sources

```sh
watch flux get sources git
```
