FROM "eqalpha/keydb:x86_64_v6.0.16"

ADD start-keydb-server.sh /usr/bin/
RUN chmod +x /usr/bin/start-keydb-server.sh

CMD ["start-keydb-server.sh"]