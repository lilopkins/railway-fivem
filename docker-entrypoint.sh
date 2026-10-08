#!/bin/sh

cat << END | tee /tmp/frpc.toml
serverAddr = "$PROXY_ADDR"
serverPort = ${PROXY_PORT:-7000}
transport.poolCount = 16

[[proxies]]
name = "fivem-tcp"
localIP = "127.0.0.1"
localPort = 30120
remotePort = ${PROXY_REMOTE_PORT:-30120}
type = "tcp"

[[proxies]]
name = "fivem-udp"
localIP = "127.0.0.1"
localPort = 30120
remotePort = ${PROXY_REMOTE_PORT:-30120}
type = "udp"
END
frpc -c /tmp/frpc.toml &
FRPC_PID=$!

/sbin/tini -- /usr/bin/entrypoint +set txDataPath /config/txData $*
kill $FRPC_PID

