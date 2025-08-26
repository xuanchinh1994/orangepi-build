#!/bin/bash
# Script to launch the GPIO binary with hardcoded values

# Các dòng 'read' bị xóa hoặc comment đi
# read NUM_LEDS < /boot/num_led.txt
# read LED_COLOR < /boot/led_color.txt
# echo $NUM_LEDS # Không cần echo nữa
# echo $LED_COLOR # Không cần echo nữa

# Đường dẫn tuyệt đối đến file binary
# GPIO_BIN="/home/voyd/.config/autostart/voyd_gpio.bin" # Hoặc voyd_gpio_new.bin nếu bạn đã build với tên đó

# if [[ -x "$GPIO_BIN" ]]; then
#     echo "Launching $GPIO_BIN with hardcoded values (10 LEDs, Color W)..."
#     # Sử dụng giá trị trực tiếp trong lệnh sudo
#     sudo "$GPIO_BIN" -l 10 --color "W" & # Chạy nền
#     echo "Process launched in background."
# else
#     echo "Error: GPIO binary not found or not executable at $GPIO_BIN" >&2
#     exit 1
# fi

# exit 0
read NUM_LEDS < /boot/num_led.txt 
read LED_COLOR < /boot/led_color.txt 
echo $NUM_LEDS 
echo $LED_COLOR

# sudo /home/voyd/.config/autostart/voyd_gpio.bin -l $NUM_LEDS --color "$LED_COLOR"
sudo /home/voyd/.config/autostart/voyd_gpio_new.bin -l 20 --color "W"