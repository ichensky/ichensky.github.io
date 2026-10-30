# PC Backup Script

This script provides a robust, fail-safe backup backbone using `rsync` to synchronize the `home` directory, critical system configurations (/etc), package lists, and Flatpak overrides to an `external drive`.

Designed for execution with `root privileges`, the script includes safety checks to verify that the external drive is mounted before writing, preventing accidental data dumps to the root filesystem.


#### A robust shell script for automated PC backups using `rsync`

```sh
#!/bin/sh

# Destination path
mountpoint="/media/USER/System"
dest="$mountpoint/pc/backup"
logs="$mountpoint/pc/logs"

# Refuse to write to the root filesystem if the backup drive is absent
if ! mountpoint -q "$mountpoint"; then
    printf 'Error: backup drive is not mounted at %s\n' "$mountpoint" >&2
    exit 1
fi

if ! mkdir -p "$dest"; then
    printf 'Error: cannot create backup directory %s\n' "$dest" >&2
    exit 1
fi

if ! mkdir -p "$logs"; then
    printf 'Error: cannot create log directory %s\n' "$logs" >&2
    exit 1
fi

#
# Installed packages
#
dpkg -l > "$dest/dpkg.txt"
apt-mark showmanual > "$dest/manual_packages.list"
if command -v snap >/dev/null 2>&1; then
    snap list > "$dest/snap_packages.txt"
fi
if command -v flatpak >/dev/null 2>&1; then
    flatpak list --app --columns=application,origin > "$dest/flatpak_packages.txt"
fi

log_file="$logs/rsync-$(date '+%Y-%m-%d_%H-%M-%S').log"

# 1. Backup /home/iso_images separately (outside /home/USER)
rsync -aAXv --delete \
    --progress \
    --stats \
    --relative \
    --log-file="$log_file" \
    /home/iso_images \
    "$dest"

# 2. Backup /home/USER using include/exclude filters with --delete-excluded
rsync -aAXv --delete --delete-excluded \
    --progress \
    --stats \
    --relative \
    --log-file-format="[%t] %i %n" \
    --log-file="$log_file" \
    --include='/home/USER' \
    --include='/home/USER/xxx/***' \
    --include='/home/USER/Documents/***' \
    --include='/home/USER/Downloads/***' \
    --include='/home/USER/Desktop/***' \
    --include='/home/USER/.gitconfig' \
    --include='/home/USER/.config/' \
    --include='/home/USER/.config/xfce4/***' \
    --include='/home/USER/.config/syncthing/***' \
    --include='/home/USER/.gnupg/***' \
    --include='/home/USER/.local/' \
    --include='/home/USER/.local/share/' \
    --include='/home/USER/.local/share/flatpak/' \
    --include='/home/USER/.local/share/flatpak/overrides/***' \
    --include='/home/USER/.local/share/remmina/***' \
    --include='/home/USER/.ssh/***' \
    --include='/home/USER/.profile' \
    --include='/home/USER/.bashrc' \
    --include='/home/USER/.bash_history' \
    --include='/home/USER/.var' \
    --include='/home/USER/.var/app' \
    --include='/home/USER/.var/app/org.mozilla.thunderbird' \
    --include='/home/USER/.var/app/org.mozilla.thunderbird/.thunderbird/***' \
    --exclude='*' \
    /home/USER \
    "$dest"

# 3. Backup /etc paths using include/exclude filters with --delete-excluded
rsync -aAXv --delete --delete-excluded \
    --progress \
    --stats \
    --relative \
    --log-file-format="[%t] %i %n" \
    --log-file="$log_file" \
    --include='/etc' \
    --include='/etc/wireguard/***' \
    --include='/etc/NetworkManager/' \
    --include='/etc/NetworkManager/system-connections/***' \
    --include='/etc/NetworkManager/VPN/***' \
    --include='/etc/ufw/***' \
    --include='/etc/apt/' \
    --include='/etc/apt/sources.list.d/***' \
    --include='/etc/apt/trusted.gpg.d/***' \
    --include='/etc/apt/keyrings/***' \
    --exclude='*' \
    /etc \
    "$dest"

# 4. Backup /usr paths using include/exclude filters with --delete-excluded
rsync -aAXv --delete --delete-excluded \
    --progress \
    --stats \
    --relative \
    --log-file-format="[%t] %i %n" \
    --log-file="$log_file" \
    --include='/usr' \
    --include='/usr/share/' \
    --include='/usr/share/keyrings/***' \
    --exclude='*' \
    /usr \
    "$dest"

# 5. Backup system-wide Flatpak overrides (Flatseal settings)
rsync -aAXv --delete --delete-excluded \
    --progress \
    --stats \
    --relative \
    --log-file-format="[%t] %i %n" \
    --log-file="$log_file" \
    --include='/var' \
    --include='/var/lib/' \
    --include='/var/lib/flatpak/' \
    --include='/var/lib/flatpak/overrides/***' \
    --exclude='*' \
    /var \
    "$dest"

# Check if rsync exited successfully (0) and log/print the outcome
if [ $? -eq 0 ]; then
    msg="[SUCCESS] Backup finished at $(date '+%Y-%m-%d %H:%M:%S')"
    echo "$msg" | tee -a "$logs/backup_log.txt"
else
    msg="[ERROR] Backup failed at $(date '+%Y-%m-%d %H:%M:%S')"
    echo "$msg" | tee -a "$logs/backup_log.txt"
    exit 1
fi
```

### Extensibility
This script serves as a `foundational backbone` and can be extended with specialized options tailored to specific workflows, such as archiving cron jobs or network rules.

### Log Inspection
Following execution, `log` files can be reviewed to verify which files were modified, removed, or updated during the process.