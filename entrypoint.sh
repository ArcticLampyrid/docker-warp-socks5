#!/bin/sh
mkdir -p /opt/wgcf
wgcf register --accept-tos --config /opt/wgcf/wgcf-account.toml
wgcf generate --config /opt/wgcf/wgcf-account.toml
mv wgcf-profile.conf /opt/wireproxy.conf

echo -e "\n[Socks5]\nBindAddress = 0.0.0.0:40000" >>/opt/wireproxy.conf

if [ -n "$SOCKS5_USERNAME" ]; then
	echo -e "\nUsername = $SOCKS5_USERNAME\nPassword = $SOCKS5_PASSWORD" >>/opt/wireproxy.conf
fi

wireproxy -c /opt/wireproxy.conf
