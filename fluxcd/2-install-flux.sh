flux bootstrap github \
  --components-extra=image-reflector-controller,image-automation-controller \
  --owner=$GITHUB_USER \
  --repository=fluxcd-test \
  --branch=main \
  --path=fluxcd/apps \
  --read-write-key \
  --personal

git pull

## add docker registry certs
$(cd apps/flux-system && \
  kustomize edit add patch --path docker-certs.yaml \
  --kind Deployment --name image-reflector-controller \
  --namespace flux-system --version apps/v1)