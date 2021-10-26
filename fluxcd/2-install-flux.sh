flux bootstrap github \
  --components-extra=image-reflector-controller,image-automation-controller \
  --owner=$GITHUB_USER \
  --repository=fluxcd-test \
  --branch=main \
  --path=fluxcd/apps \
  --read-write-key \
  --personal


flux create image update flux-system \
--git-repo-ref=flux-system \
--git-repo-path="./fluxcd/apps" \
--checkout-branch=main \
--push-branch=main \
--author-name=fluxcdbot \
--author-email=fluxcdbot@users.noreply.github.com \
--commit-template="{{range .Updated.Images}}{{println .}}{{end}}" \
--export > ./apps/flux-system-automation.yaml