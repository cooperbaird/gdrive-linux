# gdrive-linux
Simple Google Drive client for Linux.

This scripts uses [rclone](https://rclone.org/) and [inotify](https://en.wikipedia.org/wiki/Inotify) to monitor a local directory and automatically copy changes to your Google Drive. Directory structure/hierarchy is preserved in the copy and dotfiles are ignored. The script monitors for `create` and `modify` events and uses `rclone copyto` instead of `rclone sync` or `bisync` for safety reasons (nothing will be deleted from your Google Drive automatically). This configuration is my personal preference, but the script can be modified to mirror/sync files 1:1 with deletion if you'd like (using `rclone sync` or `bisync`).

I may modify this script later to also monitor file `move` events and make the corresponding change in Google Drive. I didn't initially include this because it would involve running an `rclone delete` to remove the file from its previous location in Google Drive.

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
If there's any files/directories in your Google Drive that you want copied to `GDRIVE_DIR` on your machine, you'll have to explicitly run an `rclone copy`, since this script only copies creations and updates one way (from your machine to Google Drive).

https://rclone.org/commands/rclone_copy/
