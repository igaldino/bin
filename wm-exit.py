#!/bin/python
import sys
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

import subprocess

class MyWindow(Gtk.Window):

  def __init__(self):
    Gtk.Window.__init__(self, title="Exit")
    self.set_icon_name("system-shutdown")
    self.set_position(Gtk.WindowPosition.CENTER_ALWAYS)
    self.set_resizable(False)
    self.set_keep_above(True)
    self.set_urgency_hint(True)
    self.set_border_width(10)
    self.stick()

    accel = Gtk.AccelGroup()
    key, mod = Gtk.accelerator_parse('Escape')
    accel.connect(key, mod, Gtk.AccelFlags.VISIBLE, Gtk.main_quit)
    self.add_accel_group(accel)

    self.box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
    self.add(self.box)

    self.image = Gtk.Image(stock="gtk-quit", icon_size=6)
    self.box.pack_start(self.image, True, True, 0)

    self.message = Gtk.Label("What do you want to do?")
    self.box.pack_start(self.message, True, True, 0)

    self.buttonbox = Gtk.ButtonBox(orientation=Gtk.Orientation.VERTICAL, layout_style="start")
    self.box.pack_start(self.buttonbox, True, True, 0)

    self.poweroff_image = Gtk.Image(icon_name="system-shutdown-symbolic")

    self.poweroff = Gtk.Button(label="Power-off", always_show_image=True)
    self.poweroff.set_image(self.poweroff_image)
    self.poweroff.connect("clicked", self.on_poweroff_clicked)
    self.buttonbox.pack_start(self.poweroff, True, True, 0)

    self.reboot_image = Gtk.Image(icon_name="system-reboot-symbolic")

    self.reboot = Gtk.Button(label="Reboot", always_show_image=True)
    self.reboot.set_image(self.reboot_image)
    self.reboot.connect("clicked", self.on_reboot_clicked)
    self.buttonbox.pack_start(self.reboot, True, True, 0)

    self.logout_image = Gtk.Image(icon_name="system-log-out-symbolic")

    self.logout = Gtk.Button(label="Log Out", always_show_image=True)
    self.logout.set_image(self.logout_image)
    self.logout.connect("clicked", self.on_logout_clicked)
    self.buttonbox.pack_start(self.logout, True, True, 0)

    self.cancel_image = Gtk.Image(icon_name="cancel-symbolic")

    self.cancel = Gtk.Button(label="Cancel", always_show_image=True)
    self.cancel.set_image(self.cancel_image)
    self.cancel.connect("clicked", Gtk.main_quit)
    self.buttonbox.pack_start(self.cancel, True, True, 0)

  def on_logout_clicked(self, widget):
    self.hide()
    response = self.are_you_sure("log out")
    if response == Gtk.ResponseType.YES:
      if len(sys.argv) > 1:
        if sys.argv[1] == "openbox":
          subprocess.call(["openbox", "--exit"])
        elif sys.argv[1] == "i3":
          subprocess.call(["i3-msg", "exit"])
        else:
          print "wm-exit.py: you need to specify which window manager you are using (openbox or i3)"
    Gtk.main_quit()

  def on_reboot_clicked(self, widget):
    self.hide()
    response = self.are_you_sure("reboot")
    if response == Gtk.ResponseType.YES:
      subprocess.call(["systemctl", "reboot"])
    Gtk.main_quit()

  def on_poweroff_clicked(self, widget):
    self.hide()
    response = self.are_you_sure("power off")
    if response == Gtk.ResponseType.YES:
      subprocess.call(["systemctl", "poweroff"])
    Gtk.main_quit()

  def are_you_sure(self, action):
    dialog = Gtk.MessageDialog(self, 0, Gtk.MessageType.WARNING, Gtk.ButtonsType.YES_NO, "Are you sure you want to " + action + "?")
    dialog.set_title("Exit")
    dialog.set_icon_name("system-shutdown")
    response = dialog.run()
    dialog.destroy()
    return response

win = MyWindow()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()

