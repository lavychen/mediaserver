FROM alpine:3.9
LABEL maintainer="Pedro Sanders <fonosterteam@fonoster.com>"

COPY config /etc/asterisk/
COPY run.sh /
RUN apk add --no-cache --update curl tini asterisk=15.7.4-r0 asterisk-sounds-en && chmod +x /run.sh

ENTRYPOINT ["tini", "-v", "--"]
CMD ["/run.sh"]
