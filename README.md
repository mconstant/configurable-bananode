# build #
`docker build -t [your-dockerhub-username]/[your-image-name]:[your-tag] .`

# run #
e.g.

`docker run -e "CONFIG_NODE_WEBSOCKET_ENABLE=true" -e "CONFIG_NODE_RPC_ENABLE=true" -e "CONFIG_RPC_ENABLE_CONTROL" [your-dockerhub-username]/[your-image-name]:[your-tag]`