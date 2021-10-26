#create Github secrets
kubectl create secret -n flux-system generic github-ssh-credentials \
    --from-literal identity="$(cat $GITHUB_IDENTITY)" \
    --from-literal identity.pub="$(cat $GITHUB_IDENTITY.pub)" \
    --from-literal known_hosts="$(ssh-keyscan github.com)"

#add flux git souce for dev env configurations
flux create source git dev --url ssh://git@github.com/luca-iachini/fluxcd-test --secret-ref github-ssh-credentials \
 --branch main --interval 30s --export | tee apps/dev.yaml

#create flux configurations for dev env
flux create kustomization dev --source dev --path "./fluxcd/dev/apps/" --prune true \
  --interval 10m --export | tee -a apps/dev.yaml

#add helm release for the demo app
flux create helmrelease app1 --source GitRepository/dev --values ../helm/app1/values.dev.yaml --chart "./charts/go" \
  --create-target-namespace --target-namespace dev \
  --interval 30s --export | sed -E 's/(tag: .*)/\1 # {"$imagepolicy": "flux-system:dev-app1:tag"}/g' | tee dev/apps/app1.yaml

#create image repository for the demo app
flux create image repository app1 --image=$DOCKER_REG_URL/fluxcd-test/app1 \
--interval=1m --secret-ref regcred \
--export > ./dev/apps/app1-registry.yaml

#create image policy for the demo app. Con
#flux create image policy dev-app1 \
#--image-ref=app1 \
#--select-semver=0.0.x \
#--export > ./dev/apps/app1-policy.yaml

flux create image policy dev-app1 \
--image-ref=app1 \
--select-numeric=asc \
--filter-regex='^main-[a-f0-9]+-(?P<ts>[0-9]+)' \
--filter-extract='$ts' \
--export > ./dev/apps/app1-policy.yaml

# configure flux write back to update the helm release manifest
flux create image update dev-apps \
--git-repo-ref=dev \
--git-repo-path="./fluxcd/dev/apps" \
--checkout-branch=main \
--push-branch=main \
--author-name=fluxcdbot \
--author-email=fluxcdbot@users.noreply.github.com \
--commit-template="{{range .Updated.Images}}{{println .}}{{end}}" \
--export > ./dev/apps/dev-apps-automation.yaml