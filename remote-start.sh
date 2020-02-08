#!/bin/bash

cd "$(dirname "$0")"

clean_up() {
	rm -rf ./build
	exit
}

trap clean_up SIGHUP SIGINT SIGTERM

scp -r src/ pi@smartgrobot.local:/home/pi/sg-wifi

ssh pi@smartgrobot.local 'sudo kill -9 $(sudo lsof -ti tcp:4001)' > /dev/null
ssh pi@smartgrobot.local 'sh /home/pi/sg-wifi/start.sh'
