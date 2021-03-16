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
fi

# setup ROS environment
echo "Sourcing ROS environment for $ROS_DISTRO..."
source "/opt/ros/$ROS_DISTRO/setup.bash"

# setup application catkin workspace environment
if [ -f "/app_ws/setup.sh" ]; then
    echo "Sourcing application environment..."
    source "/app_ws/setup.sh"
elif [ -f "/app_ws/devel/setup.bash" ]; then
    echo "Sourcing application environment..."
    source "/app_ws/devel/setup.bash"
else
    echo "No application environment to source, map catkin workspace into the container and perform catkin make."
fi

# exec provided command
exec "$@"
