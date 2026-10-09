FROM docker.io/spritsail/fivem:latest

WORKDIR /usr/share/frp
RUN curl -Lo /tmp/frp.tar.gz https://github.com/fatedier/frp/releases/download/v0.71.0/frp_0.71.0_linux_amd64.tar.gz && \
    tar --strip-components 1 -xzvf /tmp/frp.tar.gz && \
    mkdir -p /usr/local/bin && \
    ln -s /usr/share/frp/frpc /usr/local/bin/frpc && \
    rm -f /tmp/frp.tar.gz

WORKDIR /config
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]

