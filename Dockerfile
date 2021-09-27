FROM eqalpha/keydb:x86_64_v6.2.0 

RUN apt-get update && apt-get install -yq dnsutils vim-tiny && apt-get clean && rm -rf /var/lib/apt/lists

ADD fly /fly/
ADD keydb.conf /etc/

# Run with Prometheus stats exporter
CMD ["/fly/hivemind", "/fly/Procfile"]

# Run without Prometheus
# CMD ["/fly/start_keydb.sh"]
