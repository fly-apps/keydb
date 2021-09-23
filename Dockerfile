FROM eqalpha/keydb:alpine_x86_64_v6.2.0

RUN apt-get update && apt-get install -yq dnsutils vim-tiny && apt-get clean && rm -rf /var/lib/apt/lists

ADD fly /fly/
ADD keydb.conf /etc/

# Run with exporter
CMD ["/fly/hivemind", "/fly/Procfile"]

# Just run
# CMD ["/fly/start_keydb.sh"]
