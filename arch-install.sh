#!/bin/sh

DEVICE=/dev/vda
KEYMAP=us-acentos
SWAPGB=2
HOSTNAME=stuart

BASE="base linux grub sudo git spice-vdagent"
GNOME="gnome gnome-software-packagekit-plugin gvfs-mtp gvfs-gphoto2 ffmpegthumbnailer gst-libav gst-plugins-ugly"
#APPS="firefox-i18n-pt-br libreoffice-fresh-pt-br audacity keepassxc polari meld lollypop easytag gnome-builder flatpak-builder"
APPS=

PACKAGES="${BASE} ${GNOME} ${APPS}"

sgdisk --zap-all ${DEVICE}
sgdisk -n 0:0:+1MiB -t 0:ef02 -c 0:boot ${DEVICE}
sgdisk -n 0:0:-${SWAPGB}GiB -t 0:8300 -c 0:root ${DEVICE}
sgdisk -n 0:0:0 -t 0:8200 -c 0:swap ${DEVICE}

mkfs.btrfs ${DEVICE}2
mkswap ${DEVICE}3

mount ${DEVICE}2 /mnt
swapon ${DEVICE}3

pacstrap /mnt ${PACKAGES}

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt echo "${HOSTNAME}" > /etc/hostname

arch-chroot /mnt ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime
arch-chroot /mnt echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt echo "LANG=pt_BR.UTF-8" > /etc/locale.conf

arch-chroot /mnt echo "KEYMAP=${KEYMAP}" > /etc/vconsole.conf

arch-chroot /mnt grub-install --target=i386-pc --recheck ${DEVICE}
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

arch-chroot /mnt useradd -m -G wheel isaque
echo "Enter isaque password"
arch-chroot /mnt passwd isaque
arch-chroot /mnt sed -i "s/^# %wheel/%wheel/1" /etc/sudoers

arch-chroot /mnt sed -i "s/^#WaylandEnable/WaylandEnable/1" /etc/gdm/custom.conf
arch-chroot /mnt systemctl enable gdm
arch-chroot /mnt systemctl enable NetworkManager

umount -R /mnt

reboot

