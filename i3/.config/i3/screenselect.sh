#!/bin/sh

choices="$(ls ~/.screenlayout/)\nManual"
chosen=$(echo -e "$choices" | dmenu -i)

case "$chosen" in
    Manual) arandr ;;
    *) cat ~/.screenlayout/$chosen > ~/.config/i3/screenlayout.sh
       ~/.config/i3/screenlayout.sh ;;
esac
