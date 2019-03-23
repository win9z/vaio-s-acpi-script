# VAIO S ACPI script
ACPI script for Sony VAIO S series that makes special keys useful on Linux.
# FEATURES
- STAMINA / SPEED switches CPU and fan mode between silent and performance
- FN+F1 disables / enables touchpad
- FN+F9&F10 (Zoom-Out&In) decreases / increases keyboard backlight timeout
- VAIO button switches keyboard backlight mode
- ASSIST button enabled fan force mode
# INSTALLING
- Install acpid - apt install acpid 
- Install TLP - apt install tlp (Optional)
- Place files into /etc/acpi/
- Restart pc
# TROUBLESHOOTING
- If on keypress nothing happens
Check daemon status - systemctl status acpid.service 
 Then, if daemon inactive:
  1) Enable autostart - systemctl enable acpid.service
  2) Start it now - systemctl start acpid.service
 Or if daemon active:
  1) Check keypress detect work - acpi_listen
  2) Then press some FN or VAIO keys, terminal must show ACPI events
  If events doesn't shows up - that is acpid problem
  If events shows up, but nothing happens:
   1) Open /etc/acpi/events/sony-laptop
   2) Replace "sony/hotkey SNY5001:00" by acpi_listen output after keypress
   3) Open  /etc/acpi/actions/sony-laptop.sh
   4) Replace ACPI event codes by acpi_listen outputs after non-working keypreses
  If all of this is ok, but /sys/devices/platform/sony-laptop sysfs node doesn't exist:
   1) Check if module loaded - lsmod | grep sony_laptop
   2) It must be loaded because it included it kernel many years ago
