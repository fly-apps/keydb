ARG KEYDB_VERSION=6.2.2
FROM eqalpha/keydb:x86_64_v${KEYDB_VERSION}

RUN apt-get update && apt-get install -yq dnsutils vim-tiny && apt-get clean && rm -rf /var/lib/apt/lists

ADD fly /fly/
ADD keydb.conf /etc/

# Run with Prometheus stats exporter
CMD ["/fly/hivemind", "/fly/Procfile"]

# Run without Prometheus
# CMD ["/fly/start_keydb.sh"]
