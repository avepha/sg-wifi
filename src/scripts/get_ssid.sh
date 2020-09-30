#!/bin/bash
BASE_DIR=$(dirname "$0")
GETID_PATH=$BASE_DIR/get_id.sh
echo -n "@sg-lts-$("$GETID_PATH")"
