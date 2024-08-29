#!/bin/sh

choices="Suspend\nShutdown\nReboot"

chosen=$(echo -e "$choices" | dmenu -i)

case "$chosen" in
    Suspend) systemctl suspend ;;
    Shutdown) shutdown now ;;
    Reboot) reboot ;;
esac
