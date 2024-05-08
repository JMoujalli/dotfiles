#!/bin/sh

chosen=$(echo -e "100\n200\n300" | dmenu -i -p "Select a DPI:")

case "$chosen" in
    *) echo xrandr --dpi $chosen > ~/.config/i3/saveddpi.sh
       ~/.config/i3/saveddpi.sh ;;
esac
