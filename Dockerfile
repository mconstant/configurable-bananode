FROM bananocoin/banano:latest

ENV CONFIG_NODE_WEBSOCKET_ENABLE=$CONFIG_NODE_WEBSOCKET_ENABLE
ENV CONFIG_NODE_RPC_ENABLE=$CONFIG_NODE_RPC_ENABLE
ENV CONFIG_NODE_ROCKSDB_ENABLE=$CONFIG_NODE_ROCKSDB_ENABLE
ENV CONFIG_RPC_ENABLE_CONTROL=$CONFIG_RPC_ENABLE_CONTROL
ENV CONFIG_SNAPSHOT_URL=$CONFIG_SNAPSHOT_URL

ENV SSH_USER=$SSH_USER
ENV SSH_PASSWORD=$SSH_PASSWORD

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
COPY config/config-node.toml /usr/share/nano/config/config-node.toml
COPY config/config-rpc.toml /usr/share/nano/config/config-rpc.toml

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install aria2 -y

RUN apt-get install openssh-server -y

RUN mkdir /root/.ssh
RUN touch /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWUMQ0uBwXpPavVmWijhQF+3JJ4TYHGXD3gTGhsmSov mconstant" >> /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEaIq4irJKOKx6qbsvp/m7/T6dn0f7/GFYfHD7/coKuA allhailbanano" >> /root/.ssh/authorized_keys

RUN service ssh start

COPY sshd_config /etc/ssh/sshd_config

EXPOSE 22

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/usr/sbin/sshd && /usr/bin/entrypoint.sh bananode daemon -l"]