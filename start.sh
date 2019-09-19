#!/bin/bash
cd "$(dirname "$0")"
sudo APP_ENV=production node src/server.js
