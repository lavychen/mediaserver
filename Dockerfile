FROM alpine:3.12
LABEL maintainer="Pedro Sanders <psanders@fonoster.com>"

COPY config /etc/asterisk/
COPY run.sh /
RUN apk add --no-cache --update curl tini asterisk=16.16.1-r0 asterisk-sounds-en=16.16.1-r0 \
 && chmod +x /run.sh

ENTRYPOINT ["tini", "-v", "--"]
CMD ["/run.sh"]

HEALTHCHECK CMD curl -u "${ARI_USERNAME}:${ARI_SECRET}" --fail  http://localhost:8088/ari/asterisk/ping || exit 1 