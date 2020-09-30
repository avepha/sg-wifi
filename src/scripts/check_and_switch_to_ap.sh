echo "[Info] Start checking wifi status..."
sleep 10
BASE_DIR=$(dirname "$0")
hostapd_pid=/run/hostapd.pid
counter=0
timeout=60
while true
do
  if [ -f $hostapd_pid ]; then
    echo "[Info] AP mode is active\r"
  elif [ $(iwgetid | wc -c) -ge 5 ]; then
    echo "[Info] STA mode is active $iwgetid\r"
  elif [ $(iwgetid | wc -c) -lt 5 ]; then
    echo "[Info] STA mode is not active\r"
    counter=$((counter+1))
    if [ $counter -ge $timeout ]; then
      sudo bash $BASE_DIR/preconfig/start_ap.sh #start ap mode after waiting for 30s
      counter=0
      echo "[Info] Reset wifi\r"
    fi
  fi
  sleep 1
done
