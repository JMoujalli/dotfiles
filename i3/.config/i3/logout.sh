#!/bin/sh

choices="Lock\nShutdown\nReboot"

chosen=$(echo "$choices" | dmenu -i)

case "$chosen" in
    Lock) i3lock-fancy -g ;;
    Shutdown) shutdown now ;;
    Reboot) reboot ;;
esac
