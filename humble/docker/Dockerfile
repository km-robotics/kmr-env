FROM ghcr.io/km-robotics/althack-ros2-humble-dev_cudagl_virtualgl:edge

# Ubuntu 22.04 Jammy + ROS2 Humble + cudagl

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

RUN apt update && apt install -y apt-utils apt-file inetutils-ping wget curl htop iotop iftop tcpdump byobu mc less aptitude

# Webots dependencies
# from https://github.com/cyberbotics/webots-docker/blob/master/Dockerfile
RUN wget https://raw.githubusercontent.com/cyberbotics/webots/master/scripts/install/linux_runtime_dependencies.sh
RUN chmod +x linux_runtime_dependencies.sh && ./linux_runtime_dependencies.sh && rm ./linux_runtime_dependencies.sh

# Webots
RUN wget -O webots.tar.bz2 "https://github.com/cyberbotics/webots/releases/download/R2023a/webots-R2023a-x86-64.tar.bz2" && tar -xjf webots.tar.bz2 -C /opt && rm -rf webots.tar.bz2
ENV WEBOTS_HOME=/opt/webots
ENV QTWEBENGINE_DISABLE_SANDBOX=1
ENV AUDIODEV=null

# Pylon SDK
RUN wget -O pylon.deb "https://www.baslerweb.com/fp-1615275617/media/downloads/software/pylon_software/pylon_6.2.0.21487-deb0_amd64.deb" && dpkg -i pylon.deb && rm -rf pylon.deb && apt-get -f install
ENV PYLON_ROOT=/opt/pylon

# Install X virtual framebuffer to be able to use Webots without GPU and GUI (e.g. CI)
RUN apt install --yes xvfb

# ROS packages basic set for desktop development
RUN apt install -y \
    ros-humble-desktop-full

# ROS packages taken from JM Galactic install as of 20230329
RUN apt install -y \
    ros-humble-ackermann-msgs \
    ros-humble-backward-ros \
    ros-humble-camera-calibration-parsers \
    ros-humble-control-msgs \
    ros-humble-control-toolbox \
    ros-humble-controller-manager \
    ros-humble-controller-manager-msgs \
    ros-humble-diff-drive-controller \
    ros-humble-eigen-stl-containers \
    ros-humble-foxglove-bridge \
    ros-humble-foxglove-msgs \
    ros-humble-graph-msgs \
    ros-humble-gripper-controllers \
    ros-humble-image-proc \
    ros-humble-joint-state-broadcaster \
    ros-humble-joint-state-publisher \
    ros-humble-joint-trajectory-controller \
    ros-humble-launch-param-builder \
    ros-humble-moveit-resources-fanuc-description \
    ros-humble-moveit-resources-fanuc-moveit-config \
    ros-humble-moveit-resources-panda-description \
    ros-humble-moveit-resources-panda-moveit-config \
    ros-humble-moveit-resources-pr2-description \
    ros-humble-object-recognition-msgs \
    ros-humble-octomap \
    ros-humble-octomap-msgs \
    ros-humble-position-controllers \
    ros-humble-random-numbers \
    ros-humble-ros-testing \
    ros-humble-rosbag2-storage-mcap \
    ros-humble-rosbridge-library \
    ros-humble-rosbridge-server \
    ros-humble-rqt-robot-monitor \
    ros-humble-rqt-runtime-monitor \
    ros-humble-ruckig \
    ros-humble-sensor-msgs-py \
    ros-humble-test-msgs \
    ros-humble-tf-transformations \
    ros-humble-topic-tools \
    ros-humble-urdfdom-py \
    ros-humble-vision-msgs \
    ros-humble-warehouse-ros \
    ros-humble-xacro

# repair not working bash completion for ROS (rosbash not present in /etc/bash_completion.d/)
#RUN ln -s /opt/ros/noetic/share/rosbash/rosbash /etc/bash_completion.d/rosbash

# allow running sudo under non-privileged user in entrypoint script to create, copy and change ownership of files and directories
# should not matter because one is already able to run code inside docker container as root
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers

# Webots config
RUN mkdir -p /root/.config/Cyberbotics
ADD Webots-R2023a.conf /root/.config/Cyberbotics/

# Byobu config
RUN mkdir -p /root/.byobu && touch /root/.byobu/.welcome-displayed
ADD keybindings.tmux /root/.byobu/keybindings.tmux

# application catkin workspace, to be mapped into the container
RUN mkdir -p /app_ws
ENV APP_WS=/app_ws

# entrypoint script that will create pseudo home user directory with basic configuration of some tools and will source ROS environments
ADD rep.sh /
RUN chmod ugo+x /rep.sh

WORKDIR /app_ws


# cleanup
RUN rm -rf /var/lib/apt/lists/

# allow interactive installations of packages when container is used by regular user
ENV DEBIAN_FRONTEND=

ENTRYPOINT ["/rep.sh"]

# -l to use "login shell" which will process default profile/bashrc and enable bash completion
# -2 to force terminal with colors support
CMD ["/usr/bin/byobu", "-l", "-2"]
