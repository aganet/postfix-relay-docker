#!/bin/bash

: "${RELAY_HOST:=smtp.gmail.com}"
: "${RELAY_PORT:=587}"
: "${MYHOSTNAME:=example.com}"
: "${MYNETWORKS:=127.0.0.0/8}"
: "${SASL_PASSWD:=}"

if [ -z "$SASL_PASSWD" ]; then
  echo "Error: SASL_PASSWD environment variable must be set (in the format: user:password)."
  exit 1
fi

# Create the SASL password file
echo "[${RELAY_HOST}]:${RELAY_PORT} ${SASL_PASSWD}" > /etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd

# Set Postfix configuration using postconf
postconf -e "maillog_file = /dev/stdout"
postconf -e "myhostname = ${MYHOSTNAME}"
postconf -e "relayhost = [${RELAY_HOST}]:${RELAY_PORT}"
postconf -e "smtp_sasl_auth_enable = yes"
postconf -e "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd"
postconf -e "smtp_sasl_security_options = noanonymous"
postconf -e "smtp_tls_security_level = encrypt"
postconf -e "smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt"
postconf -e "smtp_use_tls = yes"
postconf -e "mynetworks = ${MYNETWORKS}"
postconf -e "inet_interfaces = all"
postconf -e "smtpd_relay_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination"

# (optional)
postconf -e "debug_peer_level = 2"
postconf -e "smtp_tls_loglevel = 1"
postconf -e "smtp_tls_note_starttls_offer = yes"

# Set the mailname (Debian specific configuration)
echo "${MYHOSTNAME}" > /etc/mailname

#fix the missing resolv on chroot and dns issue
cp /etc/resolv.conf /var/spool/postfix/etc/resolv.conf

/usr/sbin/postfix start-fg
