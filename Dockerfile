ARG KEYDB_VERSION=6.2.2
FROM eqalpha/keydb:x86_64_v${KEYDB_VERSION}

RUN apt-get update && apt-get install -yq dnsutils ca-certificates curl && apt-get clean && rm -rf /var/lib/apt/lists

RUN curl -s -L https://github.com/oliver006/redis_exporter/releases/download/v1.35.0/redis_exporter-v1.35.0.linux-amd64.tar.gz \
  | tar --strip-components=1 -z -C /usr/local/bin/ -x --no-anchored redis_exporter

RUN curl -s -L https://github.com/DarthSim/hivemind/releases/download/v1.0.6/hivemind-v1.0.6-linux-amd64.gz \
  |  gunzip > /usr/local/bin/hivemind \
  && chmod 0755 /usr/local/bin/hivemind

ADD fly /fly/
ADD keydb.conf /etc/

# Run with Prometheus stats exporter
CMD ["/usr/local/bin/hivemind", "/fly/Procfile"]

# Run without Prometheus
# CMD ["/fly/start_keydb.sh"]
