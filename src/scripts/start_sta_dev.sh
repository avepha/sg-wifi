#!/bin/bash
BASE_DIR=$(dirname "$0")
sudo cp $BASE_DIR/sta_dhcpcd.conf /etc/dhcpcd.conf
sudo cp $BASE_DIR/dev_wpa.conf /etc/wpa_supplicant/wpa_supplicant.conf
sudo systemctl disable hostapd
sudo systemctl disable dnsmasq
sudo systemctl stop hostapd
sudo systemctl stop dnsmasq
sudo service dhcpcd restart
sudo wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
sudo dhcpcd wlan0
