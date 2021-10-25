kubectl create secret -n flux-system generic github-ssh-credentials \
    --from-literal identity="$(cat $GITHUB_IDENTITY)" \
    --from-literal identity.pub="$(cat $GITHUB_IDENTITY.pub)" \
    --from-literal known_hosts="$(ssh-keyscan github.com)"

flux create source git dev --url ssh://git@github.com/luca-iachini/fluxcd-test.git --secret-ref github-ssh-credentials \
 --branch main --interval 30s --export | tee apps/dev.yaml

 flux create kustomization dev --source dev --path "./fluxcd/dev/apps/" --prune true \
  --interval 10m --export | tee -a apps/dev.yaml

flux create helmrelease app1 --source GitRepository/dev --values ../helm/app1/values.dev.yaml --chart "./charts/go" --target-namespace dev \
  --interval 30s --export | tee dev/apps/app1.yaml