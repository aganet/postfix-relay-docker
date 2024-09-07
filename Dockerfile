FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y postfix libsasl2-2 libsasl2-modules sasl2-bin mailutils ca-certificates dnsutils iputils-ping vim && \
    rm -rf /var/lib/apt/lists/*

COPY postfix.init.sh /usr/local/bin/postfix.init.sh
RUN chmod +x /usr/local/bin/postfix.init.sh

EXPOSE 25

CMD ["/usr/local/bin/postfix.init.sh"]

