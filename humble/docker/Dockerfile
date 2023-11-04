FROM ghcr.io/km-robotics/althack-ros2-humble-dev_cudagl_virtualgl:edge

# Ubuntu 22.04 Jammy + ROS2 Humble + cudagl

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

RUN apt update && apt install -y apt-utils apt-file inetutils-ping wget curl htop iotop iftop tcpdump byobu mc less aptitude grc

# install Docker to be used to control host's Docker daemon if neccessary
RUN curl -fsSL https://get.docker.com | bash

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
RUN apt update && apt install --yes xvfb

# ROS packages basic set for desktop development
RUN apt update && apt install -y \
    ros-humble-desktop-full

# ROS packages taken from JM Galactic install as of 20230519
RUN apt update && apt install -y \
    ros-humble-ackermann-msgs \
    ros-humble-ament-clang-format \
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
    ros-humble-xacro \
    ros-humble-orocos-kdl-vendor \
    freeglut3-dev \
    libomp-dev \
    liblua5.4-dev \
    ntpdate \
    python3-pymodbus \
    python3-collada \
    python3-transitions \
    python3-pygraphviz \
    python3-socketio

RUN pip install -U \
    transforms3d \
    python-json-logger \
    watchdog \
    simplejpeg \
    datadog \
    safer \
    streamz \
    xonsh \
    flatten-dict

# install additional useful packages AFTER ROS (allows faster rebuilds of this image when just adding some useful package)
RUN apt update && apt install -y \
    python3-ipython \
    bpython

# additional rosdep sources
RUN bash -c 'echo -e "yaml https://raw.githubusercontent.com/km-robotics/rosdep_kmr_public/master/rosdep/python.yaml" > /etc/ros/rosdep/sources.list.d/19-kmr-public.list'
# rosdep update (run under root and then copied to user's home via entrypoint.sh when the image is run)
RUN rosdep update --include-eol-distros

# allow running sudo under non-privileged user in entrypoint script to create, copy and change ownership of files and directories
# should not matter because one is already able to run code inside docker container as root
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers

# Webots config
RUN mkdir -p /root/.config/Cyberbotics
ADD Webots-R2023a.conf /root/.config/Cyberbotics/

# Byobu config
RUN mkdir -p /root/.byobu && touch /root/.byobu/.welcome-displayed
ADD keybindings.tmux /root/.byobu/keybindings.tmux
ADD windows.tmux /root/.byobu/windows.tmux
ADD .tmux.conf /root/.byobu/.tmux.conf

# application catkin workspace, to be mapped into the container
RUN mkdir -p /app_ws
ENV APP_WS=/app_ws

# entrypoint script that will create pseudo home user directory with basic configuration of some tools
ADD entrypoint.sh /
RUN chmod ugo+x /entrypoint.sh

# helper script to be sourced after shell starts up (and .bashrc is processed) via tmux predefined windows
ADD source_app.sh /
RUN chmod ugo+x /source_app.sh

WORKDIR /app_ws


# NO cleanup so that we can run apt install right away while using the image
#RUN rm -rf /var/lib/apt/lists/


# allow interactive installations of packages when container is used by regular user
ENV DEBIAN_FRONTEND=

# enable colors in terminal
ENV TERM=xterm-256color


ENTRYPOINT ["/entrypoint.sh"]

# launch entrypoint (prepared pseudo home directory)
# that execs bash as a non-login shell (does not process .bashrc) 
# then from it launch byobu
#  -2 to force terminal with colors support
# byobu will launch shell inside itself via default-command / default-shell (will process .bashrc and set environment variables, ...)
#  .bashrc has to be provided by the user (volume mount)
# byobu windows.tmux config will launch one window and source /source_app.sh in it, which will go into $APP_WS directory
#  and source ROS and application environment if present, bash completion will be setup and not overriden by anything
#  (because this is the last step)
CMD ["bash", "-c", "/usr/bin/byobu", "-2"]
