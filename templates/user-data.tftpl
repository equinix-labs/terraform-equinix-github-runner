#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export RUNNER_CFG_PAT=${personal_access_token}

apt-get -qy update
apt-get -qy install build-essential gcc jq

svc_user="ghrunner"
useradd -m $svc_user -s /bin/bash
cd /home/$svc_user || exit

curl -fsSL https://raw.githubusercontent.com/actions/runner/main/scripts/create-latest-svc.sh -o /tmp/create-latest-svc.sh
bash /tmp/create-latest-svc.sh -s ${runner_scope} -u $svc_user -l equinix-metal,$(hostname)
