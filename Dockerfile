FROM mongo:8.0.3

COPY init-replica.sh /init-replica.sh
RUN chmod +x /init-replica.sh

ENTRYPOINT ["/init-replica.sh"]
