#!/bin/bash

./config.sh --url $RUNNER_URL \
	--token $RUNNER_TOKEN \
	--name $RUNNER_NAME \
	--work $RUNNER_WORK_DIRECTORY \
	--replace \
	--unattended

./run.sh
