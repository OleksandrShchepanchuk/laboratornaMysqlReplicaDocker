FROM ubuntu:latest

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-client mailutils  && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y curl


COPY check_replication.sh /usr/local/bin/check_replication.sh

RUN touch /var/log/check_replication.log

RUN chmod +x /usr/local/bin/check_replication.sh

COPY ./loop.sh ./loop.sh
CMD ["./loop.sh"]


