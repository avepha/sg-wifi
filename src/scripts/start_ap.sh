#!/bin/bash
hostapd_pid=/run/hostapd.pid
BASE_DIR=$(dirname "$0")
sudo cp $BASE_DIR/preconfig/ap_dhcpcd.conf /etc/dhcpcd.conf

if [ "$#" -gt 0 ] && [ "$#" -eq 2 ]; then
  if [ $(echo $1 | wc -c) -lt 1 ] || [ $(echo $2 | wc -c) -lt 8 ]; then
    echo "Illigal parameter, require 2 arguments [ssid] [password]"
    exit 1
  fi
  sudo cp $BASE_DIR/preconfig/ap_hostapd.conf /etc/hostapd/hostapd.conf
  echo "ssid=$1" >>/etc/hostapd/hostapd.conf
  echo "wpa_passphrase=$2" >>/etc/hostapd/hostapd.conf
elif [ "$#" -eq 0 ]; then
  echo "Using default ap name";
else
  echo "Illigal parameter, require 2 arguments [ssid] [password]"
  exit 1
fi

sudo pkill -9 wpa_supplicant &
if [ -f $hostapd_pid ]; then # ap is working
  echo "updating wifi from ap => ap"
  sudo systemctl restart hostapd &
  sudo systemctl restart dnsmasq &
  wait
  echo "done"
else
  echo "Changing wifi from sta => ap"
  sudo service dhcpcd restart &
  sudo systemctl enable hostapd &
  sudo systemctl enable dnsmasq &
  wait
  sudo systemctl start hostapd &
  sudo systemctl start dnsmasq &
  wait
  echo "done"
fi
