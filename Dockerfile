FROM node:14-alpine3.12
LABEL maintainer="Pedro Sanders <psanders@fonoster.com>"

COPY config /etc/asterisk/
COPY run.sh /

RUN apk add --no-cache --update \
 tini \
 asterisk \
 asterisk-speex \
 asterisk-curl \
 asterisk-sounds-en \
 asterisk-sounds-moh \
 python3 \ 
 && npm -g config set user root \  
 && npm -g install @fonoster/dispatcher \
 && chmod +x /run.sh

ENTRYPOINT ["tini", "-v", "--"]
CMD ["/run.sh"]

HEALTHCHECK CMD asterisk -rx "pjsip show registrations" | grep -q "Registered" || exit 1
