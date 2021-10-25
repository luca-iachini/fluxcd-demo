flux bootstrap github \
  --components-extra=image-reflector-controller,image-automation-controller \
  --owner=$GITHUB_USER \
  --repository=fluxcd-test \
  --branch=main \
  --path=fluxcd/apps \
  --read-write-key \
  --personal
