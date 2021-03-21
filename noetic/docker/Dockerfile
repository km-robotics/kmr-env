FROM osrf/ros:noetic-desktop-full-focal

# Ubuntu 20.04 Focal

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

RUN apt update && apt install -y apt-utils wget curl htop iotop iftop tcpdump byobu mc less aptitude

# Webots dependencies
# from https://github.com/cyberbotics/webots-docker/blob/master/Dockerfile
RUN wget https://raw.githubusercontent.com/cyberbotics/webots/master/scripts/install/linux_runtime_dependencies.sh
RUN chmod +x linux_runtime_dependencies.sh && ./linux_runtime_dependencies.sh && rm ./linux_runtime_dependencies.sh

# Webots
RUN wget -O webots.tar.bz2 "https://github.com/cyberbotics/webots/releases/download/R2021a/webots-R2021a-x86-64.tar.bz2"
RUN tar -xjf webots.tar.bz2 -C /opt && rm -rf webots.tar.bz2
ENV WEBOTS_HOME=/opt/webots
ENV QTWEBENGINE_DISABLE_SANDBOX=1
ENV AUDIODEV=null

# Install X virtual framebuffer to be able to use Webots without GPU and GUI (e.g. CI)
RUN apt update && apt install --yes xvfb

# ==== from https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.1/ubuntu20.04-x86_64/base/Dockerfile ====

# ==== base

RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 11.2.1

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-11-2=11.2.146-1 \
    cuda-compat-11-2 \
    && ln -s cuda-11.2 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=11.2 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 driver>=450,driver<451"

# ==== runtime

ENV NCCL_VERSION 2.8.4

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-11-2=11.2.1-1 \
    libnpp-11-2=11.3.2.139-1 \
    cuda-nvtx-11-2=11.2.67-1 \
    libcublas-11-2=11.4.1.1026-1 \
    libcusparse-11-2=11.4.0.135-1 \
    libnccl2=$NCCL_VERSION-1+cuda11.2 \
    && rm -rf /var/lib/apt/lists/*

# apt from auto upgrading the cublas package. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold libcublas-11-2 libnccl2

# ==== devel

RUN apt-get update && apt-get install -y --no-install-recommends \
    libtinfo5 libncursesw5 \
    cuda-cudart-dev-11-2=11.2.146-1 \
    cuda-command-line-tools-11-2=11.2.1-1 \
    cuda-minimal-build-11-2=11.2.1-1 \
    cuda-libraries-dev-11-2=11.2.1-1 \
    cuda-nvml-dev-11-2=11.2.67-1 \
    libnpp-dev-11-2=11.3.2.139-1 \
    libnccl-dev=2.8.4-1+cuda11.2 \
    libcublas-dev-11-2=11.4.1.1026-1 \
    libcusparse-dev-11-2=11.4.0.135-1 \
    && rm -rf /var/lib/apt/lists/*

# apt from auto upgrading the cublas package. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold libcublas-dev-11-2 libnccl-dev
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

# ==== end ====

# latest git
RUN apt update && apt install -y software-properties-common
RUN apt-add-repository -y ppa:git-core/ppa && apt update && apt install -y git

# ROS packages
RUN apt update && apt install -y \
    bash-completion \
    liborocos-kdl-dev \
    python3-catkin-tools \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-vcstool \
    python3-wstool \
    ros-noetic-actionlib-tutorials \
    ros-noetic-bond \
    ros-noetic-bond-core \
    ros-noetic-bondcpp \
    ros-noetic-bondpy \
    ros-noetic-camera-calibration \
    ros-noetic-camera-calibration-parsers \
    ros-noetic-collada-parser \
    ros-noetic-collada-urdf \
    ros-noetic-common-msgs \
    ros-noetic-common-tutorials \
    ros-noetic-compressed-depth-image-transport \
    ros-noetic-compressed-image-transport \
    ros-noetic-depth-image-proc \
    ros-noetic-diagnostic-aggregator \
    ros-noetic-diagnostic-analysis \
    ros-noetic-diagnostic-common-diagnostics \
    ros-noetic-diagnostics \
    ros-noetic-executive-smach \
    ros-noetic-geometry \
    ros-noetic-geometry-tutorials \
    ros-noetic-gl-dependency \
    ros-noetic-ifm3d \
    ros-noetic-image-common \
    ros-noetic-image-geometry \
    ros-noetic-image-pipeline \
    ros-noetic-image-proc \
    ros-noetic-image-publisher \
    ros-noetic-image-rotate \
    ros-noetic-image-transport-plugins \
    ros-noetic-image-view \
    ros-noetic-industrial-robot-status-controller \
    ros-noetic-industrial-robot-status-interface \
    ros-noetic-interactive-marker-tutorials \
    ros-noetic-joint-limits-interface \
    ros-noetic-joint-state-controller \
    ros-noetic-joint-trajectory-controller \
    ros-noetic-joy \
    ros-noetic-laser-assembler \
    ros-noetic-laser-filters \
    ros-noetic-laser-pipeline \
    ros-noetic-librviz-tutorial \
    ros-noetic-mk \
    ros-noetic-moveit \
    ros-noetic-moveit-python \
    ros-noetic-moveit-resources \
    ros-noetic-moveit-visual-tools \
    ros-noetic-nodelet-core \
    ros-noetic-nodelet-topic-tools \
    ros-noetic-nodelet-tutorial-math \
    ros-noetic-pcl-conversions \
    ros-noetic-pcl-msgs \
    ros-noetic-pcl-ros \
    ros-noetic-perception \
    ros-noetic-perception-pcl \
    ros-noetic-pluginlib-tutorials \
    ros-noetic-qt-dotgraph \
    ros-noetic-qt-gui \
    ros-noetic-qt-gui-cpp \
    ros-noetic-qt-gui-py-common \
    ros-noetic-qwt-dependency \
    ros-noetic-robot \
    ros-noetic-ros \
    ros-noetic-ros-base \
    ros-noetic-ros-comm \
    ros-noetic-ros-core \
    ros-noetic-ros-numpy \
    ros-noetic-ros-tutorials \
    ros-noetic-rosbash \
    ros-noetic-rosboost-cfg \
    ros-noetic-rosbridge-suite \
    ros-noetic-roscpp-core \
    ros-noetic-roscpp-tutorials \
    ros-noetic-roscreate \
    ros-noetic-roslang \
    ros-noetic-roslisp \
    ros-noetic-rosmake \
    ros-noetic-rospy-tutorials \
    ros-noetic-rqt-action \
    ros-noetic-rqt-bag \
    ros-noetic-rqt-bag-plugins \
    ros-noetic-rqt-common-plugins \
    ros-noetic-rqt-console \
    ros-noetic-rqt-dep \
    ros-noetic-rqt-graph \
    ros-noetic-rqt-gui \
    ros-noetic-rqt-gui-cpp \
    ros-noetic-rqt-gui-py \
    ros-noetic-rqt-image-view \
    ros-noetic-rqt-launch \
    ros-noetic-rqt-logger-level \
    ros-noetic-rqt-moveit \
    ros-noetic-rqt-msg \
    ros-noetic-rqt-nav-view \
    ros-noetic-rqt-plot \
    ros-noetic-rqt-pose-view \
    ros-noetic-rqt-publisher \
    ros-noetic-rqt-py-common \
    ros-noetic-rqt-py-console \
    ros-noetic-rqt-reconfigure \
    ros-noetic-rqt-robot-dashboard \
    ros-noetic-rqt-robot-monitor \
    ros-noetic-rqt-robot-plugins \
    ros-noetic-rqt-robot-steering \
    ros-noetic-rqt-runtime-monitor \
    ros-noetic-rqt-rviz \
    ros-noetic-rqt-service-caller \
    ros-noetic-rqt-shell \
    ros-noetic-rqt-srv \
    ros-noetic-rqt-tf-tree \
    ros-noetic-rqt-top \
    ros-noetic-rqt-topic \
    ros-noetic-rqt-web \
    ros-noetic-rviz-plugin-tutorials \
    ros-noetic-rviz-python-tutorial \
    ros-noetic-self-test \
    ros-noetic-smach \
    ros-noetic-smach-msgs \
    ros-noetic-smach-ros \
    ros-noetic-smclib \
    ros-noetic-stage \
    ros-noetic-stage-ros \
    ros-noetic-stereo-image-proc \
    ros-noetic-stereo-msgs \
    ros-noetic-tf2-eigen \
    ros-noetic-tf2-geometry-msgs \
    ros-noetic-tf2-tools \
    ros-noetic-theora-image-transport \
    ros-noetic-turtle-actionlib \
    ros-noetic-turtle-tf \
    ros-noetic-turtle-tf2 \
    ros-noetic-turtlesim \
    ros-noetic-urdf-parser-plugin \
    ros-noetic-urdf-tutorial \
    ros-noetic-vision-opencv \
    ros-noetic-visualization-marker-tutorials \
    ros-noetic-visualization-tutorials \
    ros-noetic-viz \
    ros-noetic-webkit-dependency \
    ros-noetic-webots-ros

# repair not working bash completion for ROS (rosbash not present in /etc/bash_completion.d/)
RUN ln -s /opt/ros/noetic/share/rosbash/rosbash /etc/bash_completion.d/rosbash

# allow running sudo under non-privileged user in entrypoint script to create, copy and change ownership of files and directories
# should not matter because one is already able to run code inside docker container as root
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers

# Webots config
RUN mkdir -p /root/.config/Cyberbotics
ADD Webots-R2021a.conf /root/.config/Cyberbotics/

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
