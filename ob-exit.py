#!/bin/python
#
# ob-exit.py by igaldino
# ======================
#
# Power-off using dbus command line (old way)
#
# $ dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 "org.freedesktop.login1.Manager.PowerOff" boolean:true
# $ dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 "org.freedesktop.login1.Manager.Reboot" boolean:true
# $ dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 "org.freedesktop.login1.Manager.Suspend" boolean:true
# $ dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 "org.freedesktop.login1.Manager.Hibernate" boolean:true
#
# Power-off using system-logind command line (new way)
#
# $ systemctl poweroff
# $ systemctl reboot
# $ systemctl suspend
# $ systemctl hibernate

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

import subprocess

class MyWindow(Gtk.Window):

    def __init__(self):
        Gtk.Window.__init__(self, title="Exit")
        self.set_icon_name("system-shutdown")
        self.set_position(Gtk.WindowPosition.CENTER_ALWAYS)
        self.set_resizable(False);
        self.set_keep_above(True);
        self.set_urgency_hint(True);
        self.stick();

        accel = Gtk.AccelGroup()
        key, mod = Gtk.accelerator_parse('Escape')
        accel.connect(key, mod, Gtk.AccelFlags.VISIBLE, Gtk.main_quit)
        self.add_accel_group(accel)

        self.box = Gtk.Box()
        self.box.set_homogeneous(True);
        self.add(self.box)

        self.logout = Gtk.Button(label="Log Out")
        self.logout.connect("clicked", self.on_logout_clicked)
        self.box.pack_start(self.logout, True, True, 0)

        self.reboot = Gtk.Button(label="Reboot")
        self.reboot.connect("clicked", self.on_reboot_clicked)
        self.box.pack_start(self.reboot, True, True, 0)

        self.poweroff = Gtk.Button(label="Power-off")
        self.poweroff.connect("clicked", self.on_poweroff_clicked)
        self.box.pack_start(self.poweroff, True, True, 0)

    def on_logout_clicked(self, widget):
        response = self.are_you_sure()
        if response == Gtk.ResponseType.YES:
            subprocess.call(["openbox", "--exit"])
        Gtk.main_quit()

    def on_reboot_clicked(self, widget):
        response = self.are_you_sure()
        if response == Gtk.ResponseType.YES:
            subprocess.call(["systemctl", "reboot"])
        Gtk.main_quit()

    def on_poweroff_clicked(self, widget):
        response = self.are_you_sure()
        if response == Gtk.ResponseType.YES:
            subprocess.call(["systemctl", "poweroff"])
        Gtk.main_quit()

    def are_you_sure(self):
        dialog = Gtk.MessageDialog(self, 0, Gtk.MessageType.WARNING, Gtk.ButtonsType.YES_NO, "Are you sure?")
        response = dialog.run()
        dialog.destroy()
        return response

win = MyWindow()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()

