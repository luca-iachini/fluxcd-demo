cd docker-registry

mkdir auth
 docker run \
  --entrypoint htpasswd \
  httpd:2 -Bbn $DOCKER_REG_USER $DOCKER_REG_PASSWORD > auth/htpasswd

openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout certs/registry.key -out certs/registry.crt -subj "/CN=$DOCKER_REG_HOST"

sudo echo "127.0.0.1 registry.localhost" >> /etc/hosts

echo "add docker insecure registry to docker engine. copy \"insecure-registries\" : [\"$DOCKER_REG_URL\"]"

docker run -d \
  -p $DOCKER_REG_URL \
  --restart=always \
  --name registry \
  -v "$(pwd)"/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -v "$(pwd)"/certs:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
  registry:2


## docker registry secret
kubectl create secret -n flux-system docker-registry regcred --docker-server="$DOCKER_REG_URL" --docker-username="$DOCKER_REG_USER" \
  --docker-password="$DOCKER_REG_PASSWORD" --docker-email="docker@example.com"
