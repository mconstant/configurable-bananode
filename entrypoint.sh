#!/bin/bash
# Bash 'Strict Mode'
# http://redsymbol.net/articles/unofficial-bash-strict-mode
# https://github.com/xwmx/bash-boilerplate#bash-strict-mode
#set -o nounset
#set -o errexit
#set -o pipefail
#IFS=$'\n\t'

echo "Setting custom config"
sed -i "s/CONFIG_NODE_WEBSOCKET_ENABLE/$CONFIG_NODE_WEBSOCKET_ENABLE/" /usr/share/nano/config/config-node.toml
sed -i "s/CONFIG_NODE_RPC_ENABLE/$CONFIG_NODE_RPC_ENABLE/" /usr/share/nano/config/config-node.toml
sed -i "s/CONFIG_NODE_ROCKSDB_ENABLE/$CONFIG_NODE_ROCKSDB_ENABLE/" /usr/share/nano/config/config-node.toml
sed -i "s/CONFIG_RPC_ENABLE_CONTROL/$CONFIG_RPC_ENABLE_CONTROL/" /usr/share/nano/config/config-rpc.toml

echo "Downloading snapshot"
aria2c -x2 $CONFIG_SNAPSHOT_URL
echo "Untarring snapshot"
tar -xvzf $(basename $CONFIG_SNAPSHOT_URL) -C /root/BananoData/
echo "Removing snapshot archive file"
rm $(basename $CONFIG_SNAPSHOT_URL)

usage() {
	printf "Usage:\n"
	printf "  $0 bananode [daemon] [cli_options] [-l] [-v size]\n"
	printf "    daemon\n"
	printf "      start as daemon\n\n"
	printf "    cli_options\n"
	printf "      bananode cli options <see bananode --help>\n\n"
	printf "    -l\n"
	printf "      log to console <use docker logs {container}>\n\n"
	printf "    -v<size>\n"
	printf "      vacuum database if over size GB on startup\n\n"
	printf "  $0 sh [other]\n"
	printf "    other\n"
	printf "      sh pass through\n"
	printf "  $0 [*]\n"
	printf "    *\n"
	printf "      usage\n\n"
	printf "default:\n"
	printf "  $0 bananode daemon -l\n"
}

OPTIND=1
command=""
passthrough=""
db_size=0
log_to_cerr=0

if [ $# -lt 2 ]; then
	usage
	exit 1
fi

if [ "$1" = 'bananode' ]; then
	command="${command}bananode"
	shift;
	for i in $@; do
		case $i in
			"daemon" )
				command="${command} --daemon"
				;;
			* )
				if [ ${#passthrough} -ge 0 ]; then
					passthrough="${passthrough} $i"
				else
					passthrough="$i"
				fi
				;;
		esac
	done
	for i in $passthrough; do
		case $i in
			*"-v"*)
				db_size=$(echo $i | tr -d -c 0-9)
				echo "Vacuum DB if over $db_size GB on startup"
				;;
			"-l")
				echo "log_to_cerr = true"
				command="${command} --config"
				command="${command} node.logging.log_to_cerr=true"
				;;
			*)
			 	command="${command} $i"
				;;
		esac
	done
elif [ "$1" = 'sh' ]; then
	shift;
	command=""
	for i in $@; do
		if [ "$command" = "" ]; then
			command="$i"
		else
			command="${command} $i"
		fi
	done
	printf "EXECUTING: ${command}\n"
	exec $command
else
	usage
	exit 1;
fi

network="$(cat /etc/nano-network)"
case "${network}" in
	live|'')
	network='live'
	dirSuffix=''
	;;
	beta)
	dirSuffix='Beta'
	;;
	test)
	dirSuffix='Test'
	;;
esac

raidir="${HOME}/Banano${dirSuffix}"
nanodir="${HOME}/BananoData${dirSuffix}"
dbFile="${nanodir}/data.ldb"

if [ -d "${raidir}" ]; then
	echo "Moving ${raidir} to ${nanodir}"
	mv "$raidir" "$nanodir"
else
	mkdir -p "${nanodir}"
fi

if [ ! -f "${nanodir}/config-node.toml" ] && [ ! -f "${nanodir}/config.json" ]; then
	echo "Config file not found, adding default."
	cp "/usr/share/nano/config/config-node.toml" "${nanodir}/config-node.toml"
	cp "/usr/share/nano/config/config-rpc.toml" "${nanodir}/config-rpc.toml"
fi

case $command in
	*"--daemon"*)
		if [ $db_size -ne 0 ]; then
			if [ -f "${dbFile}" ]; then
				dbFileSize="$(stat -c %s "${dbFile}" 2>/dev/null)"
				if [ "${dbFileSize}" -gt $((1024 * 1024 * 1024 * db_size)) ]; then
					echo "ERROR: Database size grew above ${db_size}GB (size = ${dbFileSize})" >&2
					bananode --vacuum
				fi
			fi
		fi
		;;
esac

printf "EXECUTING: ${command}\n"

/usr/bin/entry.sh $command