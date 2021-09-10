# Media Server

> Docker image with a headless Asterisk PBX

![publish to docker](https://github.com/fonoster/mediaserver/workflows/publish%20to%20docker%20hub/badge.svg)

This repository contains a dockerized distribution of Asterisk PBX 16 for use in [Project Fonos](https://github.com/fonoster/fonos). For more documentation on how Fonos images are constructed and how to work with them, please see the [documentation](https://github.com/fonoster/fonos).

## Available Versions

You can see all images available to pull from Docker Hub via the [Tags](https://hub.docker.com/repository/docker/fonoster/fonos-mediaserver/tags?page=1) page. Docker tag names that begin with a "change type" word such as task, bug, or feature are available for testing and may be removed at any time.

> The version is the same of the Asterisk this is image is based on

## Installation

You can clone this repository and manually build it.

```
cd fonoster/mediaserver\:%%VERSION%%
docker build -t fonoster/fonos-mediaserver:%%VERSION%% .
```

Otherwise you can pull this image from docker index.

```
docker pull fonoster/fonos-mediaserver:%%VERSION%%
```

## Usage Example

The following is a basic example of using this image.

```
docker run -it \
    -p 6060:6060 \
    -p 8088:8088 \
    -e EXTERN_ADDR=${you host address} \
    -e SIPPROXY_HOST=${sip proxy address} \
    -e SIPPROXY_USERNAME=${username at sip proxy} \
    -e SIPPROXY_SECRET=${secret at sip proxy} \
    -e ENABLE_TEST_ACCOUNT=true \
    fonoster/fonos-mediaserver
```

## Image Specs

Comming soon...

## Environment Variables

Environment variables are used in the entry point script to render configuration templates. You can specify the values of these variables during `docker run`, `docker-compose up`, or in Kubernetes manifests in the `env` array.

- `ARI_EXTERNAL_URL` - Front URL for ARI API. Defaults to `http://localhost:8088`
- `ARI_USERNAME` - Username for ARI API. Defaults to `admin`
- `ARI_SECRET` - Password for ARI API. Defaults to `changeit`
- `SIPPROXY_HOST` - The SIP Proxy's IP address. **Required**
- `SIPPROXY_PORT` - The SIP Proxy's port. Defaults `5060`
- `SIPPROXY_USERNAME` - Username at SIP Proxy . **Required**
- `SIPPROXY_SECRET` - Secret at SIP Proxy . **Required**
- `EXTERN_ADDR` - IP address to advertise. **Required**
- `LOCALNET` - Local networks. Use in combination with EXTERN_ADDR
- `SIP_BINDADDR` - Where to listen for SIP traffic. Defaults to `6060`
- `DTMF_MODE` - DTMF mode. Defaults to `auto_info`
- `ENABLE_TEST_ACCOUNT` -  Configures the account `1001@test` with password `1234`. Defaults to `false`

> The test extension is `17853178070`. Using ENABLE_TEST_ACCOUNT is not recommended in production.

## Exposed ports

- `6060` - Default SIP port

## Volumes

- `root/.fonos/config` - Volume with config file. The the role should at least have a role type `SERVICE`.

## Contributing

Please read [CONTRIBUTING.md](https://github.com/fonoster/fonos/blob/main/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

- [Pedro Sanders](https://github.com/psanders)

See also the list of contributors who [participated](https://github.com/fonoster/mediaserver/contributors) in this project.

## License

Copyright (C) 2021 by Fonoster Inc. MIT License (see [LICENSE](https://github.com/fonoster/fonos/blob/main/LICENSE) for details).
