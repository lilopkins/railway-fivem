FROM docker.io/spritsail/fivem:latest

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
EXPOSE 30120/tcp
EXPOSE 30120/udp
ENTRYPOINT ["/docker-entrypoint.sh"]

