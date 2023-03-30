#!/bin/bash

# stop on error
set -e

# handle using other than root user inside a container - create home directory, copy configurations
#   you can also map /home to the container and this will not happen, your own configurations will be used instead
if [ "$HOME" != "/root" ]; then
    mkdir -p "$HOME"
    sudo chown $UID "$HOME"
    if [ ! -d "$HOME/.config" ]; then
        echo "Copying Webots configuration into newly created $HOME..."
        sudo cp -r /root/.config "$HOME/"
        sudo chown -R $UID "$HOME/.config"
    fi
    if [ ! -d "$HOME/.byobu" ]; then
        echo "Copying Byobu configuration into newly created $HOME..."
        sudo cp -r /root/.byobu "$HOME/"
        sudo chown -R $UID "$HOME/.byobu"
    fi
    if [ ! -f "$HOME/.bash_profile" ]; then
        # enable indicative prompt
        echo 'PS1='\''(\[\033[01;32m\]KMR $ROS_DISTRO\[\033[00m\]) ${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '\''' > "$HOME/.bash_profile"
    fi
fi

# no sourcing of ROS environment here
# .bashrc processing running after this will screw up bash completion at least, so it has to be done later

# exec provided command
exec "$@"
