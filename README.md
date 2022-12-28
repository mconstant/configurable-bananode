# usage example #
`docker run -e "CONFIG_NODE_WEBSOCKET_ENABLE=true" -e "CONFIG_NODE_RPC_ENABLE=true" -e "CONFIG_SNAPSHOT_URL=https://ledgerfiles.banano.cc/rocksdb-banano-2022-07-16.tgz" -e "CONFIG_RPC_ENABLE_CONTROL=false" -e "CONFIG_NODE_ROCKSDB_ENABLE=true" xmconstantx/configurable-bananode`

# build #
`docker build -t [your-dockerhub-username]/[your-image-name]:[your-tag] .`

# run #
e.g.

`docker run -e "CONFIG_NODE_WEBSOCKET_ENABLE=true" -e "CONFIG_NODE_RPC_ENABLE=true" -e "CONFIG_SNAPSHOT_URL=https://ledgerfiles.banano.cc/rocksdb-banano-2022-07-16.tgz" -e "CONFIG_RPC_ENABLE_CONTROL=false" -e "CONFIG_NODE_ROCKSDB_ENABLE=true" [your-dockerhub-username]/[your-image-name]:[your-tag]`