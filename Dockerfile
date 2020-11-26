FROM "eqalpha/keydb:x86_64_v6.0.16"
RUN apt-get update && apt-get install -yq dnsutils vim-tiny && apt-get clean && rm -rf /var/lib/apt/lists

ADD scripts/* /usr/bin/
ADD keydb.conf /etc/

CMD ["start.sh"]