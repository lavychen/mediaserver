FROM alpine:3.9
LABEL maintainer="Pedro Sanders <fonosterteam@fonoster.com>"

RUN apk add --no-cache tini
ENTRYPOINT ["tini", "-v", "--"]
COPY config /etc/asterisk/
COPY run.sh /
RUN apk add --update asterisk=15.7.4-r0 asterisk-sounds-en && chmod +x /run.sh

CMD ["/run.sh"]
