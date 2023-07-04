#!/bin/bash

set -e

runner_scope=${1}
runner_name=${2}

function fatal() {
	echo "error: $1" >&2
	exit 1
}

case "$OSTYPE" in
darwin*) echo "Running on: OSX" ;;
linux*) echo "Running on: LINUX" ;;
*) echo "unknown OS: $OSTYPE" ;;
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
		fatal "apt-get or yum commands not found"
	fi
else
	fatal "your operating system is not supported"
fi

if [ -z "${runner_scope}" ]; then fatal "supply scope as argument 1"; fi
if [ -z "${RUNNER_CFG_PAT}" ]; then fatal "RUNNER_CFG_PAT must be set before calling"; fi
if [ -z "${runner_name}" ]; then runner_name=$(hostname); fi

echo "Waiting online runner ${runner_name} @ ${runner_scope}"

which curl || fatal "curl required.  Please install in PATH with apt-get, brew, etc"
which jq || fatal "jq required.  Please install in PATH with apt-get, brew, etc"

base_api_url="https://api.github.com/orgs"
if [[ "$runner_scope" == *\/* ]]; then
	base_api_url="https://api.github.com/repos"
fi

#--------------------------------------
# Ensure online
#--------------------------------------
for ((i = 1; i <= 20; i++)); do
	runner_status=$(curl -s -X GET ${base_api_url}/${runner_scope}/actions/runners?per_page=100 -H "accept: application/vnd.github.everest-preview+json" -H "authorization: token ${RUNNER_CFG_PAT}" |
		jq -M -j ".runners | .[] | select(.name == \"${runner_name}\") | .status")

	if [ -z "${runner_status}" ]; then
		echo "Could not find runner with name ${runner_name}"
	else
		echo "Runner ${runner_name} status: ${runner_status}"

		if [ "${runner_status}" == "online" ]; then
			exit 0
		fi
	fi
	echo "Waiting 10 seconds before trying again..."
	sleep 10
done

fatal "Runner ${runner_name} still not online after 20 attempts"
