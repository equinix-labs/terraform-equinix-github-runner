#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

runner_scope=${1}
runner_name=${2}

case "$OSTYPE" in
darwin*) echo "OSX" ;;
linux*) echo "LINUX" ;;
*) echo "unknown: $OSTYPE" ;;
esac

if [[ "$OSTYPE" =~ ^darwin ]]; then
	brew install jq curl
elif [[ "$OSTYPE" =~ ^linux ]]; then
	if command -v apt-get >/dev/null; then
		apt-get -qy update
		apt-get -qy install jq curl
	elif command -v yum >/dev/null; then
		yum update -y
		yum install jq curl -y
	else
		exit 1
	fi
else
	exit 1
fi

output=$(curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/delete.sh | bash -s $runner_scope $runner_name)

# Check if the output contains a not find runner error
if [[ $output =~ "error: Could not find runner with name ${runner_name}" ]]; then
	echo "Warning: Could not find runner with name ${runner_name}"
	exit 0
fi
