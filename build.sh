#!/bin/bash

export JOB_NAME='janus'
export DESCRIPTION='janus'

git-cat git@git.thermeon.com:build_utils.git build.sh | bash -x
