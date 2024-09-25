# Start Xmodmap to switch CapsLock to Control.
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# Activate numlock. Must install numlockx. Is this the best method to do this?
numlockx &

session=${1:-xfce}

case $session in
    i3|i3wm           ) exec i3;;
    xfce|xfce4        ) exec startxfce4;;
    # No known session, try to run it as command
    *                 ) exec $1;;
esac
