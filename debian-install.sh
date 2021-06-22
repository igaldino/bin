#!/bin/sh

apt install -y arc-theme flatpak fonts-ubuntu git gvfs-backends papirus-icon-theme redshift-gtk rsync tlp tlp-rdw unrar

mkdir -p /etc/X11/xorg.conf.d
cat<<EOF | tee -a /etc/X11/xorg.conf.d/30-touchpad.conf
Section "InputClass"
  Identifier "libinput touchpad catchall"
  Driver "libinput"
  MatchIsTouchpad "on"
  MatchDevicePath "/dev/input/event*"
  Option "Tapping" "on"
  Option "ClickMethod" "clickfinger"
EndSection
EOF

sed -i 's/^#greeter-hide-users=false/greeter-hide-users=false/1' /etc/lightdm/lightdm.conf

# ACER screen freeze
#sed -i 's/quiet/quiet i915.enable_rc6=0/1' /etc/default/grub
# DELL screen freeze
#sed -i 's/quiet/quiet video=SVIDEO-1:d/1' /etc/default/grub
# Coffee Lake TSC issue
#sed -i 's/quiet/quiet tsc=reliable/1' /etc/default/grub
# Disable usb autosuspend
#sed -i 's/quiet/quiet usbcore.autosuspend=-1/1' /etc/default/grub
# Disable ipv6
sed -i 's/quiet/quiet ipv6.disable=1/1' /etc/default/grub
sed -i 's/^GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=0/1' /etc/default/grub
sed -i 's/quiet/quiet splash loglevel=3/1' /etc/default/grub
update-grub

# SSD
#systemctl enable fstrim.timer

