Note: linux/amd64 only at the moment. See the Containerfile FROM
line. Lots of amd64-only bits in the jinwookjung/rdf-openroad-ray base
image.

```shell
podman build \
    --platform=linux/amd64 \
        --tag ghcr.io/ibm/lunchpail-openroad:0.3.5 .
```

## TODO whenever we support arm64

```shell
podman manifest create ghcr.io/ibm/lunchpail-openroad:0.3.5
podman build \
    --platform=linux/arm64/v8,linux/amd64 \
        --manifest ghcr.io/ibm/lunchpail-openroad:0.3.5 .
```

Then, to push:

```shell
podman manifest push ghcr.io/ibm/lunchpail-openroad:0.3.5
```
