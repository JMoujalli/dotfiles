#!/bin/sh

choices="$(ls ~/.screenlayout/)\nManual"
if [ -z "$(ls ~/.screenlayout/)" ]; then
    choices="Manual"
else
    choices="$(ls ~/.screenlayout/)\nManual"
fi
chosen=$(echo "$choices" | dmenu -i)

case "$chosen" in
    "") ~/.config/i3/screenlayout.sh ;;
    Manual) arandr ;;
    *) cat ~/.screenlayout/$chosen > ~/.config/i3/screenlayout.sh
       ~/.config/i3/screenlayout.sh ;;
esac
