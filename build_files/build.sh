#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux rclone restic godot git git-lfs sddm sddm-themes kitty chibi-scheme


dnf5 -y copr enable solopasha/hyprland 
dnf5 -y install hyprland xdg-desktop-portal-hyprland hyprland-contrib hyprland-plugins hyprpaper hyprpicker hypridle hyprlock hyprsunset hyprpolkitagent hyprsysteminfo hyprland-autoname-workspaces hyprshot hyprpanel hyprnome hyprdim pyprland

# Disable COPRs so they don't end up enabled on the final image: 
dnf5 -y copr disable solopasha/hyprland

# Make sure 'sddm' group exists (skip if already present)
if ! getent group sddm >/dev/null; then
    groupadd -r sddm
fi

# Make sure 'sddm' user exists (skip if already present)
if ! id -u sddm >/dev/null 2>&1; then
    useradd -r -g sddm -d /var/lib/sddm -s /usr/bin/nologin \
        -c "Simple Desktop Display Manager" sddm
fi

# Ensure home directory ownership is correct
mkdir -p /var/lib/sddm
chown sddm:sddm /var/lib/sddm

# Services to enable
systemctl enable podman.socket
systemctl enable sddm.service
