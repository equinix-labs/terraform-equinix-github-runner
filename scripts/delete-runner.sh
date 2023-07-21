#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

runner_scope=${1}
runner_name=${2}

#--------------------------------------
# Ensure offline
#--------------------------------------
echo "Ensure offline runner ${runner_name} @ ${runner_scope} before deletion"

which curl || fatal "curl required.  Please install in PATH with apt-get, brew, etc"
which jq || fatal "jq required.  Please install in PATH with apt-get, brew, etc"

base_api_url="https://api.github.com/orgs"
if [[ "$runner_scope" == *\/* ]]; then
	base_api_url="https://api.github.com/repos"
fi

for ((i = 1; i <= 20; i++)); do
	runner_status=$(curl -s -X GET "${base_api_url}/${runner_scope}/actions/runners?per_page=100" -H "accept: application/vnd.github.everest-preview+json" -H "authorization: token ${RUNNER_CFG_PAT}" | jq -e -M -j ".runners | .[] | select(.name == \"${runner_name}\") | .status" || echo "")

	if [ -z "${runner_status}" ]; then
		echo "Could not find runner with name ${runner_name}"
	else
		echo "Runner ${runner_name} status: ${runner_status}"

		if [ "${runner_status}" == "offline" ]; then
			break
		fi
	fi
	echo "Waiting 10 seconds before trying again..."
	sleep 10
done

#--------------------------------------
# Delete runner
#--------------------------------------
output=$(curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/delete.sh | bash -s $runner_scope $runner_name)
output_exit_code=$?

# Check if the output contains a not find runner error
pattern="error: Could not find runner with name ${runner_name}"
if [[ $output =~ $pattern ]]; then
	echo "Warning: Could not find runner with name ${runner_name}"
	exit 0
fi

echo $output
exit "${output_exit_code}"
