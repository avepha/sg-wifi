#!/bin/bash
hostapd_pid=/run/hostapd.pid
BASE_DIR=$(dirname "$0")
getId=$(ifconfig wlan0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' | sed -e "s/://g" | cut -c7-12)
ssid=@sg-lts-$getId

sudo cp $BASE_DIR/preconfig/ap_dhcpcd.conf /etc/dhcpcd.conf
sudo cp $BASE_DIR/preconfig/ap_hostapd.conf /etc/hostapd/hostapd.conf
echo "ssid=$ssid" >>/etc/hostapd/hostapd.conf
echo "wpa_passphrase=raspberry" >>/etc/hostapd/hostapd.conf

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
