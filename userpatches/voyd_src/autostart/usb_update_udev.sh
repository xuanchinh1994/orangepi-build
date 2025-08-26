#!/bin/bash

# Script được gọi bởi udev để xử lý cập nhật từ USB
# $1: Tên kernel của thiết bị (ví dụ: sda1, sdb1)

TARGET_USER="voyd" # Tên người dùng mục tiêu
TARGET_DIR="/home/${TARGET_USER}/.config/autostart" # Thư mục đích cần cập nhật
UPDATE_FOLDER_NAME="update_voyd" # Tên thư mục chứa bản cập nhật trên USB
MOUNT_POINT="/mnt/usb-update-temp" # Điểm mount tạm thời
LOG_TAG="usb-update-service" # Tag để ghi log
echo "=====================> Detectd USB process update via UDEV ..."
# Lấy đường dẫn thiết bị đầy đủ
DEVICE="/dev/$1"

# Ghi log bắt đầu xử lý
logger -t "$LOG_TAG" "Detected USB device partition: $DEVICE"

# Tạo điểm mount nếu chưa có
mkdir -p "$MOUNT_POINT"
if [ $? -ne 0 ]; then
    logger -t "$LOG_TAG" "Error: Failed to create mount point $MOUNT_POINT"
    exit 1
fi

# Mount thiết bị USB (thử tự động phát hiện filesystem)
# Cần quyền root để mount
mount "$DEVICE" "$MOUNT_POINT" -o ro # Mount read-only để kiểm tra trước

# Kiểm tra mount thành công
if [ $? -ne 0 ]; then
    logger -t "$LOG_TAG" "Error: Failed to mount $DEVICE to $MOUNT_POINT. Maybe not a mountable filesystem or already mounted?"
    # Dọn dẹp điểm mount nếu nó trống rỗng (chỉ khi tạo mới)
    rmdir "$MOUNT_POINT" 2>/dev/null
    exit 1
fi

logger -t "$LOG_TAG" "Successfully mounted $DEVICE to $MOUNT_POINT"

# Kiểm tra sự tồn tại của thư mục cập nhật trên USB
UPDATE_SRC_DIR="$MOUNT_POINT/$UPDATE_FOLDER_NAME"
if [ -d "$UPDATE_SRC_DIR" ]; then
    logger -t "$LOG_TAG" "Found update folder '$UPDATE_FOLDER_NAME' on $DEVICE. Preparing to update $TARGET_DIR."

    # Remount với quyền ghi để có thể copy
    umount "$MOUNT_POINT"
    mount "$DEVICE" "$MOUNT_POINT" -o rw
    if [ $? -ne 0 ]; then
        logger -t "$LOG_TAG" "Error: Failed to remount $DEVICE as read-write."
        rmdir "$MOUNT_POINT" 2>/dev/null
        exit 1
    fi

    # Đảm bảo thư mục đích tồn tại và thuộc sở hữu của người dùng target
    mkdir -p "$TARGET_DIR"
    chown -R "$TARGET_USER":"$TARGET_USER" "$(dirname "$TARGET_DIR")" # Đảm bảo thư mục cha (.config) cũng đúng owner

    # Đồng bộ hóa nội dung từ USB vào thư mục đích
    # rsync -av --delete "$UPDATE_SRC_DIR/" "$TARGET_DIR/" # Xóa file ở đích nếu không có ở nguồn
    # Hoặc dùng cp nếu chỉ muốn ghi đè và thêm mới:
    cp -a "$UPDATE_SRC_DIR"/* "$TARGET_DIR/" # Copy toàn bộ nội dung, giữ nguyên thuộc tính

    if [ $? -eq 0 ]; then
        logger -t "$LOG_TAG" "Successfully updated files in $TARGET_DIR from $DEVICE."
        # Đặt lại quyền sở hữu cho người dùng target sau khi copy (vì cp chạy bằng root)
        chown -R "$TARGET_USER":"$TARGET_USER" "$TARGET_DIR"
        logger -t "$LOG_TAG" "Set ownership of $TARGET_DIR to $TARGET_USER."
    else
        logger -t "$LOG_TAG" "Error: Failed to copy files from $UPDATE_SRC_DIR to $TARGET_DIR."
    fi

else
    logger -t "$LOG_TAG" "Update folder '$UPDATE_FOLDER_NAME' not found on $DEVICE. No update performed."
fi

# Luôn unmount thiết bị sau khi xử lý xong
umount "$MOUNT_POINT"
if [ $? -ne 0 ]; then
    logger -t "$LOG_TAG" "Warning: Failed to unmount $MOUNT_POINT. It might be busy."
else
    logger -t "$LOG_TAG" "Successfully unmounted $MOUNT_POINT."
    # Xóa điểm mount nếu nó trống
    rmdir "$MOUNT_POINT" 2>/dev/null
fi

logger -t "$LOG_TAG" "Finished processing $DEVICE."

exit 0