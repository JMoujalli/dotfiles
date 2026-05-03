# Start Xmodmap to switch CapsLock to Control.
if [ -s ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

# Start i3
exec i3
