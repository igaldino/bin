#!/bin/sh

DEVICE=/dev/sda
KEYMAP=us-acentos
SWAPGB=2
HOSTNAME=stuart
USERID=isaque
LOCALE=pt_BR.UTF-8

BASE="base bash-completion linux grub sudo efibootmgr git spice-vdagent networkmanager"
XORG="xorg-server xdg-user-dirs lightdm lightdm-gtk-greeter"
I3WM="i3-wm i3lock i3status lxterminal"
XFCE="xfce4 xfce4-goodies"
GNOME="gnome gnome-software-packagekit-plugin"
APPS="gvfs-mtp gvfs-gphoto2 ffmpegthumbnailer gst-libav gst-plugins-ugly firefox-i18n-pt-br libreoffice-fresh-pt-br audacity keepassxc meld gnome-builder flatpak-builder"

UEFI=false
if [ -f /sys/firmware/efi/fw_platform_size ]
then
  UEFI=true
fi

PACKAGES="${BASE} ${XORG} ${I3WM} ${APPS}"
DESKTOP="I3"
for i in $@; do
  case ${i} in
    xfce)
      PACKAGES="${BASE} ${XORG} ${XFCE} ${APPS}"
      DESKTOP="XFCE"
      ;;
    gnome)
      PACKAGES="${BASE} ${GNOME} ${APPS}"
      DESKTOP="GNOME"
      ;;
  esac
done

echo "Disk partition"
echo """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
sgdisk --zap-all ${DEVICE}
if [ "${UEFI}" == "true" ]; then
  sgdisk -n 0:0:+200MiB -t 0:ef02 -c 0:boot ${DEVICE}
else
  sgdisk -n 0:0:+1MiB -t 0:ef02 -c 0:boot ${DEVICE}
fi
sgdisk -n 0:0:-${SWAPGB}GiB -t 0:8300 -c 0:root ${DEVICE}
sgdisk -n 0:0:0 -t 0:8200 -c 0:swap ${DEVICE}

echo "Disk format"
echo """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if [ "${UEFI}" == "true" ]; then
  mkfs.fat -F32 ${DEVICE}1
fi
mkfs.ext4 ${DEVICE}2
mkswap ${DEVICE}3

echo "Disk mount"
echo """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
mount ${DEVICE}2 /mnt
if [ "${UEFI}" == "true" ]; then
  mkdir /mnt/boot
  mount ${DEVICE}1 /mnt/boot
fi
swapon ${DEVICE}3

echo "Package install"
echo """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
reflector --country Brazil --sort rate --save /etc/pacman.d/mirrorlist
pacstrap /mnt ${PACKAGES}

echo "CHRoot"
echo """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt echo "${HOSTNAME}" > /mnt/etc/hostname

echo "Locale setup"
echo """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime
arch-chroot /mnt echo "${LOCALE} UTF-8" > /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt echo "LANG=${LOCALE}" > /mnt/etc/locale.conf
arch-chroot /mnt echo "KEYMAP=${KEYMAP}" > /mnt/etc/vconsole.conf

echo "GRUB"
echo """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if [ "${UEFI}" == "true" ]; then
  arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux --recheck
else
  arch-chroot /mnt grub-install --target=i386-pc --recheck ${DEVICE}
fi
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo "Enter ${USERID} password"
arch-chroot /mnt useradd -m -G wheel ${USERID}
arch-chroot /mnt passwd ${USERID}
arch-chroot /mnt sed -i "s/^# %wheel/%wheel/1" /etc/sudoers

echo "${DESKTOP} setup"
echo """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if [ "${DESKTOP}" == "GNOME" ]; then
  arch-chroot /mnt sed -i "s/^#WaylandEnable/WaylandEnable/1" /etc/gdm/custom.conf
  arch-chroot /mnt systemctl enable gdm
  arch-chroot /mnt sudo -u ${USERID} dbus-launch gsettings set org.gnome.desktop.interface clock-show-date true
  arch-chroot /mnt sudo -u ${USERID} dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
  arch-chroot /mnt sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
else
  arch-chroot /mnt systemctl enable lightdm
  arch-chroot /mnt mkdir -p /etc/X11/xorg.conf.d
cat<<EOF | arch-chroot /mnt tee -a /etc/X11/xorg.conf.d/30-touchpad.conf
Section "InputClass"
  Identifier "libinput touchpad catchall"
  Driver "libinput"
  MatchIsTouchpad "on"
  MatchDevicePath "/dev/input/event*"
  Option "Tapping" "on"
  Option "ClickMethod" "clickfinger"
EndSection
EOF
fi
arch-chroot /mnt systemctl enable NetworkManager

umount -R /mnt
swapoff ${DEVICE}3

