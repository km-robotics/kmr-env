#!/bin/bash
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

# setup ROS environment
echo "Sourcing ROS environment for $ROS_DISTRO..."
source "/opt/ros/$ROS_DISTRO/setup.bash"

# setup application catkin workspace environment
if [ -f "$APP_WS/setup.sh" ]; then
    echo "Sourcing application environment from $APP_WS/setup.sh..."
    source "$APP_WS/setup.sh"
elif [ -f "$APP_WS/install/setup.bash" ]; then
    echo "Sourcing application environment from $APP_WS/install/setup.bash..."
    source "$APP_WS/install/setup.bash"
else
    echo "No application environment to source, map catkin workspace into the container, set APP_WS env variable and perform colcon build."
fi

if [ -d "$APP_WS" ]; then
    cd "$APP_WS"
fi

# exec provided command
exec "$@"
