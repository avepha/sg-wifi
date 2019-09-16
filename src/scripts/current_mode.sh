hostapd_pid=/run/hostapd.pid

if [ -f $hostapd_pid ]; then
  echo "[Info] AP mode is active"
elif [ $(iwgetid | wc -c) -ge 5 ]; then
  echo "[Info] STA mode is active $(iwgetid)"
elif [ $(iwgetid | wc -c) -lt 5 ]; then
  echo "[Info] STA mode is not active"
fi
