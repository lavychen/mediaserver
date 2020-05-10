## Maintainer

Pedro Sanders | [psanders@fonoster.com](mailto:psanders@fonoster.com)

## Description

This repository contains a dockerized distribution of Asterisk PBX 15.7 for
use in Project Fonos.

## Run Environment

Run environment variables are used in the entry point script to render configuration templates. You can specify the values of these variables during `docker run`, `docker-compose up`, or in Kubernetes manifests in the env array.

| Variable | Description | Required |
| --- | --- | --- |
| AGI_URL | agi endpoint  | Yes |
| SIPPROXY_HOST | Proxy's IP address  | Yes |
| SIPPROXY_USERNAME | Username at sipproxy  | Yes |
| SIPPROXY_SECRET | Secret at sipproxy  | Yes |
| SIP_BINDADDR | Where to listen for SIP traffic. Defaults to `6060`  | No |
| EXTERN_ADDR | IP address to advertise  | Yes |
| LOCALNET | Local networks. Use in combination with EXTERN_ADDR | No |
| DTMF_MODE | DTMF mode. Defaults to `auto_info` | No |
| ENABLE_TEST_ACCOUNT | Configures the account `1001@test` with password `1234`. Defaults to `false` | No |

> The extension to test the AGI endpoint is `1002`. Using ENABLE_TEST_ACCOUNT is not recommended in production.

## Usage

### Running with docker (pre-built)

**Pull the images**

`docker pull fonoster/routr`

**To run:**

```bash
docker run -it \
    -p 6060:6060 \
    -e EXTERN_ADDR=${you host address}
    -e AGI_URL=${agi endpoint url}
    -e SIPPROXY_HOST=${sip proxy address}
    -e SIPPROXY_USERNAME=${username at sip proxy}
    -e SIPPROXY_SECRET=${secret at sip proxy}
    fonoster/fonos-media-server
```

### Running with docker-compose

**Pull the images**

`docker-compose pull`

**To run:**

`docker-compose up --abort-on-container-exit`

**Destroying the container**

`docker-compose down`
