## Maintainer

Pedro Sanders | [psanders@fonoster.com](mailto:psanders@fonoster.com)

## Description

This repository contains a dockerized distribution of Asterisk PBX 15.7 for
use in Project Fonos.

## Run Environment

Run environment variables are used in the entry point script to render configuration templates. You can specify the values of these variables during `docker run`, `docker-compose up`, or in Kubernetes manifests in the env array.

| Variable | Description | Required |
| --- | --- | --- |
| MS_SIPPROXY_HOST | proxy's IP address  | Yes |
| MS_SIPPROXY_USERNAME | username at sipproxy  | Yes |
| MS_SIPPROXY_SECRET | secret at sipproxy  | Yes |
| MS_SIP_BINDADDR | Where to listen for SIP traffic. Defaults to `6060`  | Yes |
| MS_EXTERN_ADDR | IP address to advertise  | Yes |
| MS_AGI_URL | agi endpoint  | Yes |
| MS_LOCALNET | Local networks. Use in combination with MS_EXTERN_ADDR | No |

## Usage

### Running with docker (pre-built)

**Pull the images**

`docker pull fonoster/routr`

**To run:**

```bash
docker run -it \
    -p 6060:6060 \
    -e MS_EXTERN_ADDR=${you host address}
    -e MS_AGI_URL=${agi endpoint url}
    -e MS_SIPPROXY_HOST=${sip proxy address}
    -e MS_SIPPROXY_USERNAME=${username at sip proxy}
    -e MS_SIPPROXY_SECRET=${secret at sip proxy}
    fonoster/fonos-media-server
```

### Running with docker-compose

**Pull the images**

`docker-compose pull`

**To run:**

`docker-compose up --abort-on-container-exit`

**Destroying the container**

`docker-compose down`
