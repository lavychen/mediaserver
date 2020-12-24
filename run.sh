#!/usr/bin/env sh

USAGE=$(cat <<-END
To run this image you must provide the following environment variables:
    EXTERN_ADDR
    SIPPROXY_HOST
    SIPPROXY_USERNAME
    SIPPROXY_SECRET
    AGI_URL
END
)

[ -z "$EXTERN_PORT" ]         && { export EXTERN_PORT='0'; }
[ -z "$ARI_USERNAME" ]        && { export ARI_USERNAME='admin'; }
[ -z "$ARI_SECRET" ]          && { export ARI_SECRET='changeit'; }
[ -z "$HTTP_BINDADDR" ]       && { export HTTP_BINDADDR='0.0.0.0'; }
[ -z "$SIP_BINDADDR" ]        && { export SIP_BINDADDR='0.0.0.0:6060'; }
[ -z "$DTMF_MODE" ]           && { export DTMF_MODE='auto_info'; }
[ -z "$ENABLE_TEST_ACCOUNT" ] && { export ENABLE_TEST_ACCOUNT='false'; }
[ -z "$LOCALNET" ]            && { export LOCALNET=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}'); }

[ -z "$EXTERN_ADDR" ]       ||
[ -z "$SIPPROXY_HOST" ]     ||
[ -z "$SIPPROXY_USERNAME" ] ||
[ -z "$SIPPROXY_SECRET" ]   ||
[ -z "$AGI_URL" ]           && {
    echo "$USAGE"
    exit 1
}

sed -i.bak "s|ARI_USERNAME_PLACEHOLDER|${ARI_USERNAME}|g" /etc/asterisk/ari.conf
sed -i.bak "s|ARI_SECRET_PLACEHOLDER|${ARI_SECRET}|g" /etc/asterisk/ari.conf
sed -i.bak "s|AGI_URL_PLACEHOLDER|${AGI_URL}|g" /etc/asterisk/extensions.conf
sed -i.bak "s|SIP_BINDADDR_PLACEHOLDER|${SIP_BINDADDR}|g" /etc/asterisk/pjsip.conf
sed -i.bak "s|HTTP_BINDADDR_PLACEHOLDER|${HTTP_BINDADDR}|g" /etc/asterisk/http.conf
sed -i.bak "s|EXTERN_ADDR_PLACEHOLDER|${EXTERN_ADDR}|g" /etc/asterisk/pjsip.conf
sed -i.bak "s|EXTERN_PORT_PLACEHOLDER|${EXTERN_PORT}|g" /etc/asterisk/pjsip.conf
sed -i.bak "s|SIPPROXY_HOST_PLACEHOLDER|${SIPPROXY_HOST}|g" /etc/asterisk/pjsip_wizard.conf
sed -i.bak "s|SIPPROXY_USERNAME_PLACEHOLDER|${SIPPROXY_USERNAME}|g" /etc/asterisk/pjsip_wizard.conf
sed -i.bak "s|SIPPROXY_SECRET_PLACEHOLDER|${SIPPROXY_SECRET}|g" /etc/asterisk/pjsip_wizard.conf
sed -i.bak "s|DTMF_MODE_PLACEHOLDER|${DTMF_MODE}|g" /etc/asterisk/pjsip_wizard.conf

if [[ "$ENABLE_TEST_ACCOUNT" = "true" ]]
then
  sed -i.bak "s|LOCALNET_PLACEHOLDER|''|g" /etc/asterisk/pjsip.conf
  sed -i.bak "s|LOCALNET_PLACEHOLDER|''|g" /etc/asterisk/pjsip_wizard.conf
  sed -i.bak "s|TEST_ACCOUNT_CONTACTS_PLACEHOLDER|1|g" /etc/asterisk/pjsip_wizard.conf
else
  sed -i.bak "s|LOCALNET_PLACEHOLDER|${LOCALNET}|g" /etc/asterisk/pjsip.conf
  sed -i.bak "s|LOCALNET_PLACEHOLDER|${LOCALNET}|g" /etc/asterisk/pjsip_wizard.conf
  sed -i.bak "s|TEST_ACCOUNT_CONTACTS_PLACEHOLDER|0|g" /etc/asterisk/pjsip_wizard.conf
fi

rm /etc/asterisk/*.bak

asterisk -vvvdddf

while sleep 3600; do :; done
