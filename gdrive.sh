#!/bin/bash

###### Config Vars ######
GDRIVE_DIR=~/Drive
RCLONE_REMOTE_NAME=gdrive
#########################

if [ -z "$(which inotifywait)" ]; then
    echo "inotifywait must be installed"
    exit 1
fi

if [ -z "$(which rclone)" ]; then
    echo "rclone must be installed and linked to Google Drive"
    echo "https://rclone.org/install/"
    echo "https://rclone.org/drive/"
    exit 1
fi

if [ -z "$(which notify-send)" ]; then
    echo "notify-send must be installed"
    exit 1
fi

if [ ! -d "$GDRIVE_DIR" ]; then
    echo "Local Drive directory does not exist"
    echo "Creating $GDRIVE_DIR..."
    mkdir "$GDRIVE_DIR"
fi

inotifywait -r -m -e modify,moved_to,create --format "%w%f" --exclude '/\.' \
    "$GDRIVE_DIR" | \
    while read change; do
        remote_path=${change#$(eval echo "$GDRIVE_DIR")}
        if [ ${remote_path:0:1} = "/" ]; then
            remote_path=${remote_path#/}
        fi

        message="gdrive-linux: Upload Successful"
        rclone copyto "$change" "$RCLONE_REMOTE_NAME":"$remote_path" || message="gdrive-linux: ERROR Uploading"
        notify-send "$message" "$change"
    done
