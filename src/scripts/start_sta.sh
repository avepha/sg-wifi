#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

if [ $(echo $1 | wc -c) -lt 1 ]; then
 echo "Illegal lenth of ssid"
 exit 2
fi

if [ $(echo $2 | wc -c) -lt 1 ]; then
 echo "Illegal lenth of password"
 exit 3
fi

BASE_DIR=$(dirname "$0")
sudo cp $BASE_DIR/preconfig/sta_dhcpcd.conf /etc/dhcpcd.conf
sudo cp $BASE_DIR/preconfig/wpa.conf /etc/wpa_supplicant/wpa_supplicant.conf
sudo wpa_passphrase $1 $2 >>  /etc/wpa_supplicant/wpa_supplicant.conf
sudo systemctl disable hostapd
sudo systemctl disable dnsmasq
sudo systemctl stop hostapd
sudo systemctl stop dnsmasq
#sudo service dhcpcd restart
#sudo wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
#sudo dhcpcd wlan0
sudo reboot
