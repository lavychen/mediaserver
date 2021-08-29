FROM node:14-alpine3.12
LABEL maintainer="Pedro Sanders <psanders@fonoster.com>"

COPY config /etc/asterisk/
COPY run.sh /

RUN apk add --no-cache --update \
 curl \
 tini \
 asterisk \
 asterisk-speex \
 asterisk-curl \
 asterisk-sounds-en \
  asterisk-sounds-moh \
 python3 \ 
 && npm -g config set user root \  
 && npm -g install @fonos/dispatcher \
 && chmod +x /run.sh

ENTRYPOINT ["tini", "-v", "--"]
CMD ["/run.sh"]

HEALTHCHECK CMD curl -u "${ARI_USERNAME}:${ARI_SECRET}" --fail  http://localhost:8088/ari/asterisk/ping || exit 1
