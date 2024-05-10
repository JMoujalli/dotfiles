#!/bin/sh

choices="$(ls ~/.screenlayout/)\nDPI\nManual"
chosen=$(echo -e "$choices" | dmenu -i)

case "$chosen" in
    "") ~/.config/i3/screenlayout.sh ;;
    Manual) arandr ;;
    DPI) ~/.config/i3/dpi.sh ;;
    *) cat ~/.screenlayout/$chosen > ~/.config/i3/screenlayout.sh
       ~/.config/i3/screenlayout.sh ;;
esac
