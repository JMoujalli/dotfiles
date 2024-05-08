#!/bin/sh

choices="Shutdown\nReboot"

chosen=$(echo -e "$choices" | dmenu -i)

case "$chosen" in
    Shutdown) shutdown now ;;
    Reboot) reboot ;;
esac
