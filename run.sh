#!/usr/bin/env sh

USAGE=$(cat <<-END
To run this image you must provide the following environment variables:
    EXTERN_ADDR
    SIPPROXY_HOST
    SIPPROXY_USERNAME
    SIPPROXY_SECRET
END
)

[ -z "$ARI_EXTERNAL_URL" ]    && { export ARI_EXTERNAL_URL='http://localhost:8088'; }
[ -z "$EXTERN_PORT" ]         && { export EXTERN_PORT='0'; }
[ -z "$ARI_USERNAME" ]        && { export ARI_USERNAME='admin'; }
[ -z "$ARI_SECRET" ]          && { export ARI_SECRET='changeit'; }
[ -z "$HTTP_BINDADDR" ]       && { export HTTP_BINDADDR='0.0.0.0'; }
[ -z "$SIP_BINDADDR" ]        && { export SIP_BINDADDR='0.0.0.0:6060'; }
[ -z "$SIPPROXY_PORT" ]       && { export SIPPROXY_PORT='5060'; }
[ -z "$CODECS" ]              && { export CODECS='ulaw,alaw,gsm,g722'; }
[ -z "$DTMF_MODE" ]           && { export DTMF_MODE='inband'; }
[ -z "$ENABLE_TEST_ACCOUNT" ] && { export ENABLE_TEST_ACCOUNT='false'; }
[ -z "$LOCALNET" ]            && { export LOCALNET=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}'); }

[ -z "$EXTERN_ADDR" ]       ||
[ -z "$SIPPROXY_HOST" ]     ||
[ -z "$SIPPROXY_USERNAME" ] ||
[ -z "$SIPPROXY_SECRET" ]   && {
    echo "$USAGE"
    exit 1
}

sed -i.bak "s|ARI_USERNAME_PLACEHOLDER|${ARI_USERNAME}|g" /etc/asterisk/ari.conf
sed -i.bak "s|ARI_SECRET_PLACEHOLDER|${ARI_SECRET}|g" /etc/asterisk/ari.conf
sed -i.bak "s|SIP_BINDADDR_PLACEHOLDER|${SIP_BINDADDR}|g" /etc/asterisk/pjsip.conf
sed -i.bak "s|HTTP_BINDADDR_PLACEHOLDER|${HTTP_BINDADDR}|g" /etc/asterisk/http.conf
sed -i.bak "s|EXTERN_ADDR_PLACEHOLDER|${EXTERN_ADDR}|g" /etc/asterisk/pjsip.conf
sed -i.bak "s|EXTERN_PORT_PLACEHOLDER|${EXTERN_PORT}|g" /etc/asterisk/pjsip.conf
sed -i.bak "s|SIPPROXY_HOST_PLACEHOLDER|${SIPPROXY_HOST}|g" /etc/asterisk/pjsip_wizard.conf
sed -i.bak "s|SIPPROXY_PORT_PLACEHOLDER|${SIPPROXY_PORT}|g" /etc/asterisk/pjsip_wizard.conf
sed -i.bak "s|SIPPROXY_USERNAME_PLACEHOLDER|${SIPPROXY_USERNAME}|g" /etc/asterisk/pjsip_wizard.conf
sed -i.bak "s|SIPPROXY_SECRET_PLACEHOLDER|${SIPPROXY_SECRET}|g" /etc/asterisk/pjsip_wizard.conf
sed -i.bak "s|DTMF_MODE_PLACEHOLDER|${DTMF_MODE}|g" /etc/asterisk/pjsip_wizard.conf
sed -i.bak "s|CODECS_PLACEHOLDER|${CODECS}|g" /etc/asterisk/pjsip_wizard.conf
sed -i.bak "s|RTP_PORT_START_PLACEHOLDER|${RTP_PORT_START}|g" /etc/asterisk/rtp.conf
sed -i.bak "s|RTP_PORT_END_PLACEHOLDER|${RTP_PORT_END}|g" /etc/asterisk/rtp.conf

if [[ "$ENABLE_TEST_ACCOUNT" = "true" ]]
then
  sed -i.bak "s|LOCALNET_PLACEHOLDER||g" /etc/asterisk/pjsip.conf
  sed -i.bak "s|LOCALNET_PLACEHOLDER||g" /etc/asterisk/pjsip_wizard.conf
  sed -i.bak "s|TEST_ACCOUNT_CONTACTS_PLACEHOLDER|2|g" /etc/asterisk/pjsip_wizard.conf
else
  sed -i.bak "s|LOCALNET_PLACEHOLDER|${LOCALNET}|g" /etc/asterisk/pjsip.conf
  sed -i.bak "s|LOCALNET_PLACEHOLDER|${LOCALNET}|g" /etc/asterisk/pjsip_wizard.conf
  sed -i.bak "s|TEST_ACCOUNT_CONTACTS_PLACEHOLDER|0|g" /etc/asterisk/pjsip_wizard.conf
fi

rm /etc/asterisk/*.bak

asterisk -v

# Starts the dispatcher
export RECORDINGS_PATH="/var/spool/asterisk/recording";
export ARI_INTERNAL_URL='http://localhost:8088'; 
run

while sleep 3600; do :; done
