echo "[Info] Start checking wifi status..."
BASE_DIR=$(dirname "$0")
hostapd_pid=/run/hostapd.pid
timeout=30
echo "waiting for $timeout seconds..."

sleep $timeout
if [ -f $hostapd_pid ]; then
  echo "[Info] AP mode is active\r"
elif [ $(iwgetid | wc -c) -ge 5 ]; then
  echo "[Info] STA mode is active $iwgetid\r"
elif [ $(iwgetid | wc -c) -lt 5 ]; then
  echo "[Info] STA mode is not active\r"
  sudo bash $BASE_DIR/preconfig/start_ap.sh #start ap mode after waiting for 30s
  echo "[Info] Reset wifi\r"
fi

exit 0
