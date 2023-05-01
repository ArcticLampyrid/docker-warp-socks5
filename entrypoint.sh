#!/bin/bash

(
while ! warp-cli --accept-tos register; do
	sleep 1
	>&2 echo "Awaiting warp-svc become online..."
done
warp-cli --accept-tos set-mode proxy
warp-cli --accept-tos set-proxy-port 40001
warp-cli --accept-tos connect
warp-cli --accept-tos enable-always-on
/tcp-relay-rust 127.0.0.1:40001 0.0.0.0:40000
) &

exec warp-svc
