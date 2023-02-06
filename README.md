# gdrive-linux
Simple Google Drive client for Linux.

This script uses [rclone](https://rclone.org/) and [inotify](https://en.wikipedia.org/wiki/Inotify) to monitor a local directory and automatically copy changes to your Google Drive. Directory structure/hierarchy is preserved in the copy and dotfiles are ignored. The script monitors for `create`, `moved_to`, and `modify` events and uses `rclone copyto` instead of `rclone sync` or `bisync` for safety reasons (nothing will be deleted from your Google Drive automatically). This configuration is my personal preference, but the script can be modified to mirror/sync files 1:1 with deletion if you'd like (using `rclone sync` or `bisync`).

Moving files/directories within the monitored local directory will upload a new file/directory in the new location on Google Drive. Likewise, renaming files/directories within the monitored local directory will upload a new file/directory with the new name on Google Drive. The old file/directory will still be in your Google Drive, and you'll have to explicitly delete it if you no longer want it. This script will not delete anything from your Google Drive as-is.

## Prerequisites
- You'll need to have `rclone` [installed](https://rclone.org/install/), [configured, and linked](https://rclone.org/drive/) to your Google Drive.
- You'll also need `inotify-wait` (for monitoring local file changes) and `notify-send` (for notifications) installed (although both could be installed already depending on your distro).

## Usage
1. Download `gdrive.sh`.
2. Open `gdrive.sh` in [your favorite Text Editor](https://neovim.io/).
3. Change `RCLONE_CONF_NAME` to whatever you named your Google Drive remote during rclone setup (if you forgot, you can run `cat ~/.config/rclone/rclone.conf`, and it'll be in square brackets above the drive configuration).
4. Optionally change `GDRIVE_DIR` to point to the local directory where files will be monitored and copied from (defaults to `~/Drive` and creates the directory if it doesn't already exist on script run). `GDRIVE_DIR` is meant to be equivalent to your remote Google Drive's root directory. So, if you create `sample.txt` in `GDRIVE_DIR`, then you should see `sample.txt` at the root of your Google Drive after upload. If you create `BaseDir/NestedDir/sample.txt` in `GDRIVE_DIR`, then you should see that same directory structure and file when you open up Google Drive.
5. Make script executable: `chmod +x gdrive.sh`.
6. Run script: `./gdrive.sh`. You'll get a notification each time a file is uploaded to Google Drive.

### (Optional) Copy some files/directories from Google Drive to your machine
If there's any files/directories in your Google Drive that you want copied to `GDRIVE_DIR` on your machine, you'll have to explicitly run an `rclone copy`, since this script only copies changes one way (from your machine to Google Drive).

https://rclone.org/commands/rclone_copy/

### (Optional) Run script on user login
I do this through a [systemd user service](https://wiki.archlinux.org/title/systemd/User).
1. `mkdir -p ~/.config/systemd/user`
2. `cd ~/.config/systemd/user`
3. `touch gdrive.service`
4. Open `gdrive.service` in [your favorite Text Editor](https://neovim.io/).
5. Write the following (replacing the path to `gdrive.sh`)
```
[Unit]
Description=gdrive-linux systemd user service

[Service]
Type=simple
ExecStart=/bin/bash /path/to/gdrive.sh

[Install]
WantedBy=default.target
```
6. `systemctl --user enable gdrive.service`
7. `reboot`

Logs for the current boot can be viewed with `journalctl -b --user -u gdrive.service`.
