kubectl create secret docker-registry dockerconfigjson -n staging \
--docker-server="https://index.docker.io/v1/" \
--docker-username=okumop \
--docker-password= \  # use a dockerhub access token
--docker-email=okumop@yahoo.com