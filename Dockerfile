FROM docker.io/spritsail/fivem:latest

WORKDIR /usr/share/frp
RUN FRP_VERSION="$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/fatedier/frp/releases/latest | sed -E 's#.*/tag/v?##')" && \
    curl -fsSL -o /tmp/frp.tar.gz "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz" && \
    tar --strip-components 1 -xzvf /tmp/frp.tar.gz && \
    mkdir -p /usr/local/bin && \
    ln -s /usr/share/frp/frpc /usr/local/bin/frpc && \
    rm -f /tmp/frp.tar.gz

WORKDIR /config
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]

