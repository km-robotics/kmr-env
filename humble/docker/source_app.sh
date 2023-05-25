#!/bin/bash

# check if PATH contains ~/.local/bin, if not add it
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "Adding $HOME/.local/bin to PATH..."
    export PATH="$HOME/.local/bin:$PATH"
fi

# install ipython via pip if not installed
if ! command -v ipython &> /dev/null; then
    echo "Installing ipython..."
    pip3 install --user ipython
fi

# setup ROS environment
echo "Sourcing ROS environment for $ROS_DISTRO..."
source "/opt/ros/$ROS_DISTRO/setup.bash"

# setup application workspace environment
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
