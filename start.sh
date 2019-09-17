#!/bin/bash
cd "$(dirname "$0")"
sudo ./node_modules/.bin/babel-node src/server.js
