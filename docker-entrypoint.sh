#!/bin/sh

if [ -n "${SFTP_AUTHORIZED_KEY:-}" ]; then
    install -d -m 700 /etc/ssh
    install -d -o sftp -g config -m 700 /home/sftp/.ssh
    printf '%s\n' "$SFTP_AUTHORIZED_KEY" > /home/sftp/.ssh/authorized_keys
    chown sftp:config /home/sftp/.ssh/authorized_keys
    chmod 600 /home/sftp/.ssh/authorized_keys
    chgrp config /config
    chmod g+rwx /config
    ssh-keygen -A

    cat > /etc/ssh/sshd_config << 'END'
Port 22
LogLevel VERBOSE
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitEmptyPasswords no
PubkeyAuthentication yes
AllowUsers sftp
Subsystem sftp internal-sftp

Match User sftp
    ForceCommand internal-sftp
    PermitTTY no
    AllowTcpForwarding no
    X11Forwarding no
END
    sshd -t || exit 1
    /usr/sbin/sshd -e &
    SSHD_PID=$!
fi

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

/usr/bin/entrypoint +set txDataPath /config/txData $*
kill $FRPC_PID
[ -n "${SSHD_PID:-}" ] && kill "$SSHD_PID"
