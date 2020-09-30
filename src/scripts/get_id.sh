#!/bin/bash
getId=$(ifconfig wlan0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' | sed -e "s/://g" | cut -c7-12)
echo -n "$getId"
