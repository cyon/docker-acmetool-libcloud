# acmetool with DNS challenge hook (libcloud)

Bundling [acmetool](https://hlandau.github.io/acme/) with a [libcloud](https://libcloud.readthedocs.io/en/latest/index.html) DNS challenge hook. See the list of supported [DNS providers](https://libcloud.readthedocs.io/en/latest/dns/supported_providers.html#supported-providers).


![acmetool](https://raw.githubusercontent.com/cyon/docker-acmetool-libcloud/f42fa6930fd49544d66c4e56f38bda42c73a7a6c/img/acmetool-logo-black.png) ![libcloud](https://raw.githubusercontent.com/cyon/docker-acmetool-libcloud/f42fa6930fd49544d66c4e56f38bda42c73a7a6c/img/libcloud-logo.png)

# How to use this image

### Prepare acmetool state folder

```console
mkdir -p /my/acme/conf
wget -O /my/acme/conf/responses https://raw.githubusercontent.com/hlandau/acme/master/_doc/response-file.yaml
# Edit /my/acme/conf/responses file according to your needs
```
### Define your desired domains and DNS provider
```console
cat <<EOF > /my/acme/desired/my.example.com-desire
satisfy:
  names:
    - my.example.com

request:
  key:
    type: rsa|ecdsa
    rsa-size: 2048
    ecdsa-curve: nistp256
  ocsp-must-staple: true
  # Use staging for testing. Replace provider with:
  # https://acme-staging.api.letsencrypt.org/directory
  provider: https://acme-v01.api.letsencrypt.org/directory
  challenge:
    dns-01:
      provider: cloudflare
      email: login@example.com
      apikey: 781472cf1d657a9bf46b61dee83c4
EOF

# Make sure you lower the file permission of this file 
# because it contains sensitive information.
```

### Get the desired certificates
```console
docker run --rm -v /my/acme:/var/lib/acme cyon/acmetool-libcloud:latest

```

### Get the desired certificates and show debug output
```console
docker run --rm -v /my/acme:/var/lib/acme cyon/acmetool-libcloud:latest -- --xlog.severity=debug

```

### Inspect certificates and keys
The live folder always contains all the certificates, chains and keys. A reissue of the certificate will update the certificate and chain files.

```console
$ tree /my/acme/live/my.example.com
> live/my.example.com
> ├── cert
> ├── chain
> ├── fullchain
> ├── privkey -> ../../keys/s4cy32o8kaucxkb37k9kajkq7atof8x0/privkey
> └── url
>
> 0 directories, 5 files

```

## Use a data volume container
If you want to share the certificates and keys between containers it's best to create a named Data Volume Container. The volume destination inside the container is '/var/lib/acme'.

### Create a named data volume container
```console
docker create --name acmetool cyon/acmetool-libcloud:latest echo "Data-only container for acmetool with libcloud hook"
```


### Copy your configurations and desired setting into the volume
```console
# Run once to create all the acmetool state folders
docker run --rm --volumes-from acmetool cyon/acmetool-libcloud:latest

docker cp responses acmetool:/var/lib/acme/conf/
docker cp my.example.com-desire acmetool:/var/lib/acme/desired/
```

### Get the desired certificates
```console
docker run --rm --volumes-from acmetool cyon/acmetool-libcloud:latest

```

### Use certificate from a nginx container
```console
docker run --volumes-from acmetool --name nginx-with-acme-certs -d nginx
```