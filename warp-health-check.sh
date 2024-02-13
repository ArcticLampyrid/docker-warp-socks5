#!/bin/sh
if [ -n "$SOCKS5_USERNAME" ]; then
    curl --proxy-user $SOCKS5_USERNAME:$SOCKS5_PASSWORD -x socks5h://localhost:40000 -f -s https://www.cloudflare.com/cdn-cgi/trace
else
    curl -x socks5h://localhost:40000 -f -s https://www.cloudflare.com/cdn-cgi/trace
fi
