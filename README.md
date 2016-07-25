# Supported tags and respective `Dockerfile` links

- [`latest`, `0.1.0` (*Dockerfile*)](https://github.com/cyon/docker-acmetool-libcloud/blob/<commit hash>/Dockerfile)

# acmetool with DNS challenge hook (libcloud)

# How to use this image

```console
mkdir -p /my/acme/conf
wget -O /my/acme/conf/responses https://raw.githubusercontent.com/hlandau/acme/master/_doc/response-file.yaml
# Edit /my/acme/conf/responses file according to your needs
docker run -it --rm -v /my/acme:/var/lib/acme cyon/acmetool-libcloud:latest
```

