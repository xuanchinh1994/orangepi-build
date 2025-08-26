#!/bin/bash

# Định nghĩa thư mục mount USB và thư mục cập nhật
USB_MOUNT="/mnt/usb"
UPDATE_DIR="$USB_MOUNT/update_voyd"

# Vòng lặp để kiểm tra USB
while true; do
    # Kiểm tra xem USB có được mount không
    if mount | grep -q "$USB_MOUNT"; then
        # Kiểm tra xem thư mục update_voyd có tồn tại không
        if [ -d "$UPDATE_DIR" ]; then
            # Thực hiện cập nhật các file
            echo "=====================> Detectd USB process update via USB ..."
            # Thực hiện các lệnh cập nhật cần thiết ở đây
            # ví dụ: cp "$UPDATE_DIR"/*.desktop /home/voyd/.config/autostart/
            
            # Sau khi cập nhật, hãy unmount USB để tránh cập nhật lặp lại
            umount $USB_MOUNT
        fi
    fi
    # Đợi một khoảng thời gian trước khi kiểm tra lại
    sleep 60
done
