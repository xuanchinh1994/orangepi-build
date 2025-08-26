#!/usr/bin/env bash
read URL < /boot/url.txt 
echo $URL 
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket



python3 ~/.config/autostart/iot-dashboard/app.py &
# sleep 1
# unclutter -idle 2 &

# Wait for internet connection and open web browser
# firefox-esr -kiosk -private -url "http://127.0.0.1:5001/" >/dev/null
# firefox -kiosk -private -url "http://127.0.0.1:5001/" >/dev/null
chromium-browser --kiosk --incognito "http://127.0.0.1:5001/" >/dev/null



# echo "Waiting for internet" 
# iwgetid -r

# if [ $? -eq 0 ]; then
#     printf 'Skipping WiFi Connect\n'
#     firefox-esr -kiosk -private -url "$URL" >/dev/null
# else
#     firefox-esr -kiosk -private -url "192.168.42.1" >/dev/null &
#     echo "Starting WiFi Connect\n"
#     sudo /home/voyd/.config/autostart/ap_wifi/wifi-connect -i wlan0 -s "VOYD_wifi" -u /home/voyd/.config/autostart/ap_wifi/ui
#     printf 'WiFi Connect exit successfully\n'
#     killall firefox-esr 
#     printf 'Rebooting now \n'
#     sudo reboot
# fi
