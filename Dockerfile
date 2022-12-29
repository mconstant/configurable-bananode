FROM bananocoin/banano:latest

ENV CONFIG_NODE_WEBSOCKET_ENABLE=$CONFIG_NODE_WEBSOCKET_ENABLE
ENV CONFIG_NODE_RPC_ENABLE=$CONFIG_NODE_RPC_ENABLE
ENV CONFIG_NODE_ROCKSDB_ENABLE=$CONFIG_NODE_ROCKSDB_ENABLE
ENV CONFIG_RPC_ENABLE_CONTROL=$CONFIG_RPC_ENABLE_CONTROL
ENV CONFIG_SNAPSHOT_URL=$CONFIG_SNAPSHOT_URL

COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY config /usr/share/nano/config

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install aria2 -y

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/usr/bin/entrypoint.sh bananode daemon -l"]