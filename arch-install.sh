#!/bin/sh

DEVICE=/dev/sda
KEYMAP=us-acentos
SWAPGB=2
HOSTNAME=stuart
USERID=isaque
LOCALE=pt_BR.UTF-8

BASE="base bash-completion linux grub sudo git spice-vdagent"
XORG="xorg-server xdg-user-dirs lightdm lightdm-gtk-greeter networkmanager"
I3WM="i3-wm i3lock i3status lxterminal"
XFCE="xfce4 xfce4-goodies"
GNOME="gnome gnome-software-packagekit-plugin"
APPS="gvfs-mtp gvfs-gphoto2 ffmpegthumbnailer gst-libav gst-plugins-ugly firefox-i18n-pt-br libreoffice-fresh-pt-br audacity keepassxc polari meld lollypop easytag gnome-builder flatpak-builder"

#PACKAGES="${BASE}"
#PACKAGES="${BASE} ${XORG} ${I3WM}"
#PACKAGES="${BASE} ${XORG} ${I3WM} ${APPS}"
PACKAGES="${BASE} ${XORG} ${XFCE}"
#PACKAGES="${BASE} ${XORG} ${XFCE} ${APPS}"
#PACKAGES="${BASE} ${GNOME}"
#PACKAGES="${BASE} ${GNOME} ${APPS}"

sgdisk --zap-all ${DEVICE}
sgdisk -n 0:0:+1MiB -t 0:ef02 -c 0:boot ${DEVICE}
sgdisk -n 0:0:-${SWAPGB}GiB -t 0:8300 -c 0:root ${DEVICE}
sgdisk -n 0:0:0 -t 0:8200 -c 0:swap ${DEVICE}

mkfs.ext4 ${DEVICE}2
mkswap ${DEVICE}3

mount ${DEVICE}2 /mnt
swapon ${DEVICE}3

pacstrap /mnt ${PACKAGES}

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt echo "${HOSTNAME}" > /mnt/etc/hostname

arch-chroot /mnt ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime
arch-chroot /mnt echo "${LOCALE} UTF-8" > /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt echo "LANG=${LOCALE}" > /mnt/etc/locale.conf

arch-chroot /mnt echo "KEYMAP=${KEYMAP}" > /mnt/etc/vconsole.conf

arch-chroot /mnt grub-install --target=i386-pc --recheck ${DEVICE}
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

arch-chroot /mnt useradd -m -G wheel ${USERID}
echo "Enter ${USERID} password"
arch-chroot /mnt passwd ${USERID}
arch-chroot /mnt sed -i "s/^# %wheel/%wheel/1" /etc/sudoers

arch-chroot /mnt sed -i "s/^#WaylandEnable/WaylandEnable/1" /etc/gdm/custom.conf
arch-chroot /mnt systemctl enable lightdm
arch-chroot /mnt systemctl enable gdm
arch-chroot /mnt systemctl enable NetworkManager

umount -R /mnt

