#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

runner_scope=${1}
runner_name=${2}

output=$(curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/delete.sh | bash -s $runner_scope $runner_name)

# Check if the output contains a not find runner error
pattern="error: Could not find runner with name ${runner_name}"
if [[ $output =~ $pattern ]]; then
	echo "Warning: Could not find runner with name ${runner_name}"
	exit 0
fi
