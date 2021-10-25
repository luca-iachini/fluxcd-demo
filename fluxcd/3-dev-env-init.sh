flux create source git dev --url ssh://git@github.com/luca-iachini/fluxcd-test.git --username $GITHUB_USER --password $GITHUB_TOKEN \
 --branch main --interval 30s --export | tee apps/dev.yaml

 flux create kustomization dev --source dev --path "./fluxcd/dev/apps/" --prune true \
  --interval 10m --export | tee -a apps/dev.yaml

flux create helmrelease app1 --source GitRepository/dev --values ../helm/app1/values.dev.yaml --chart "./chart/go" --target-namespace dev \
  --interval 30s --export | tee dev/apps/app1.yaml