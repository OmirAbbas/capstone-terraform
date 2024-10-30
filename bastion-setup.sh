#!/bin/sh

sudo apt-get update -yy
sudo apt-get install -yy curl

#Download
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.320.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-linux-x64-2.320.0.tar.gz
echo "93ac1b7ce743ee85b5d386f5c1787385ef07b3d7c728ff66ce0d3813d5f46900  actions-runner-linux-x64-2.320.0.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.320.0.tar.gz

#Config
RUNNER_ALLOW_RUNASROOT=1 ./config.sh --url https://github.com/OmirAbbas/capstone-project --token A654PN4XSEDVO3LGSQZRM33HEJE7I
RUNNER_ALLOW_RUNASROOT=1 ./run.sh