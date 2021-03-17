FROM osrf/ros:kinetic-desktop-full

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

RUN apt update && apt install -y apt-utils wget curl htop iotop iftop tcpdump byobu mc less

# Webots dependencies
# from https://github.com/cyberbotics/webots-docker/blob/master/Dockerfile
RUN wget https://raw.githubusercontent.com/cyberbotics/webots/master/scripts/install/linux_runtime_dependencies.sh
RUN chmod +x linux_runtime_dependencies.sh && ./linux_runtime_dependencies.sh && rm ./linux_runtime_dependencies.sh

# Webots
RUN wget -O webots.tar.bz2 "https://github.com/cyberbotics/webots/releases/download/R2020b-rev1/webots-R2020b-rev1-x86-64_ubuntu-16.04.tar.bz2"
RUN tar -xjf webots.tar.bz2 -C /opt && rm -rf webots.tar.bz2
ENV WEBOTS_HOME=/opt/webots
ENV QTWEBENGINE_DISABLE_SANDBOX=1
ENV AUDIODEV=null

# Install X virtual framebuffer to be able to use Webots without GPU and GUI (e.g. CI)
RUN apt update && apt install --yes xvfb

# ==== from https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.1/ubuntu16.04-x86_64/base/Dockerfile ====

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates apt-transport-https gnupg-curl && \
    NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
    NVIDIA_GPGKEY_FPR=ae09fe4bbd223a84b2ccfce3f60f4b3d7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub && \
    apt-key adv --export --no-emit-version -a $NVIDIA_GPGKEY_FPR | tail -n +5 > cudasign.pub && \
    echo "$NVIDIA_GPGKEY_SUM  cudasign.pub" | sha256sum -c --strict - && rm cudasign.pub && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --auto-remove -y gnupg-curl \
    && rm -rf /var/lib/apt/lists/*

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

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-11-2=11.2.1-1 \
    libnpp-11-2=11.3.2.139-1 \
    cuda-nvtx-11-2=11.2.67-1 \
    libcublas-11-2=11.4.1.1026-1 \
    libcusparse-11-2=11.4.0.135-1 \
    && rm -rf /var/lib/apt/lists/*

# apt from auto upgrading the cublas package. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold libcublas-11-2

# ==== devel

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-dev-11-2=11.2.146-1 \
    cuda-command-line-tools-11-2=11.2.1-1 \
    cuda-minimal-build-11-2=11.2.1-1 \
    cuda-libraries-dev-11-2=11.2.1-1 \
    cuda-nvml-dev-11-2=11.2.67-1 \
    libnpp-dev-11-2=11.3.2.139-1 \
    libcublas-dev-11-2=11.4.1.1026-1 \
    libcusparse-dev-11-2=11.4.0.135-1 \
    && rm -rf /var/lib/apt/lists/*

# apt from auto upgrading the cublas package. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold libcublas-dev-11-2
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

# ==== end ====

# latest git
RUN apt update && apt install -y python-software-properties software-properties-common
RUN apt-add-repository -y ppa:git-core/ppa && apt update && apt install -y git

# ROS packages
RUN apt update && apt install -y \
    bash-completion \
    liborocos-kdl-dev \
    python-catkin-tools \
    rosbash \
    ros-kinetic-actionlib-tutorials \
    ros-kinetic-driver-base \
    ros-kinetic-bond \
    ros-kinetic-bond-core \
    ros-kinetic-bondcpp \
    ros-kinetic-bondpy \
    ros-kinetic-camera-calibration \
    ros-kinetic-camera-calibration-parsers \
    ros-kinetic-collada-parser \
    ros-kinetic-collada-urdf \
    ros-kinetic-common-msgs \
    ros-kinetic-common-tutorials \
    ros-kinetic-compressed-depth-image-transport \
    ros-kinetic-compressed-image-transport \
    ros-kinetic-depth-image-proc \
    ros-kinetic-diagnostic-aggregator \
    ros-kinetic-diagnostic-analysis \
    ros-kinetic-diagnostic-common-diagnostics \
    ros-kinetic-diagnostics \
    ros-kinetic-executive-smach \
    ros-kinetic-geometry \
    ros-kinetic-geometry-tutorials \
    ros-kinetic-gl-dependency \
    ros-kinetic-ifm3d \
    ros-kinetic-image-common \
    ros-kinetic-image-geometry \
    ros-kinetic-image-pipeline \
    ros-kinetic-image-proc \
    ros-kinetic-image-publisher \
    ros-kinetic-image-rotate \
    ros-kinetic-image-transport-plugins \
    ros-kinetic-image-view \
    ros-kinetic-industrial-core \
    ros-kinetic-industrial-robot-status-controller \
    ros-kinetic-industrial-robot-status-interface \
    ros-kinetic-interactive-marker-tutorials \
    ros-kinetic-joint-limits-interface \
    ros-kinetic-joint-qualification-controllers \
    ros-kinetic-joint-state-controller \
    ros-kinetic-joint-trajectory-action \
    ros-kinetic-joint-trajectory-action-tools \
    ros-kinetic-joint-trajectory-controller \
    ros-kinetic-joint-trajectory-generator \
    ros-kinetic-joy \
    ros-kinetic-laser-assembler \
    ros-kinetic-laser-filters \
    ros-kinetic-laser-pipeline \
    ros-kinetic-librviz-tutorial \
    ros-kinetic-mk \
    ros-kinetic-moveit \
    ros-kinetic-moveit-python \
    ros-kinetic-moveit-resources \
    ros-kinetic-moveit-sim-controller \
    ros-kinetic-moveit-visual-tools \
    ros-kinetic-nodelet-core \
    ros-kinetic-nodelet-topic-tools \
    ros-kinetic-nodelet-tutorial-math \
    ros-kinetic-pcl-conversions \
    ros-kinetic-pcl-msgs \
    ros-kinetic-pcl-ros \
    ros-kinetic-perception \
    ros-kinetic-perception-pcl \
    ros-kinetic-pluginlib-tutorials \
    ros-kinetic-qt-dotgraph \
    ros-kinetic-qt-gui \
    ros-kinetic-qt-gui-cpp \
    ros-kinetic-qt-gui-py-common \
    ros-kinetic-qwt-dependency \
    ros-kinetic-robot \
    ros-kinetic-robot-model \
    ros-kinetic-ros \
    ros-kinetic-ros-base \
    ros-kinetic-ros-comm \
    ros-kinetic-ros-core \
    ros-kinetic-ros-numpy \
    ros-kinetic-ros-tutorials \
    ros-kinetic-rosbash \
    ros-kinetic-rosboost-cfg \
    ros-kinetic-rosbridge-suite \
    ros-kinetic-roscpp-core \
    ros-kinetic-roscpp-tutorials \
    ros-kinetic-roscreate \
    ros-kinetic-roslang \
    ros-kinetic-roslisp \
    ros-kinetic-rosmake \
    ros-kinetic-rospy-tutorials \
    ros-kinetic-rqt-action \
    ros-kinetic-rqt-bag \
    ros-kinetic-rqt-bag-plugins \
    ros-kinetic-rqt-common-plugins \
    ros-kinetic-rqt-console \
    ros-kinetic-rqt-dep \
    ros-kinetic-rqt-graph \
    ros-kinetic-rqt-gui \
    ros-kinetic-rqt-gui-cpp \
    ros-kinetic-rqt-gui-py \
    ros-kinetic-rqt-image-view \
    ros-kinetic-rqt-launch \
    ros-kinetic-rqt-logger-level \
    ros-kinetic-rqt-moveit \
    ros-kinetic-rqt-msg \
    ros-kinetic-rqt-nav-view \
    ros-kinetic-rqt-plot \
    ros-kinetic-rqt-pose-view \
    ros-kinetic-rqt-publisher \
    ros-kinetic-rqt-py-common \
    ros-kinetic-rqt-py-console \
    ros-kinetic-rqt-reconfigure \
    ros-kinetic-rqt-robot-dashboard \
    ros-kinetic-rqt-robot-monitor \
    ros-kinetic-rqt-robot-plugins \
    ros-kinetic-rqt-robot-steering \
    ros-kinetic-rqt-runtime-monitor \
    ros-kinetic-rqt-rviz \
    ros-kinetic-rqt-service-caller \
    ros-kinetic-rqt-shell \
    ros-kinetic-rqt-srv \
    ros-kinetic-rqt-tf-tree \
    ros-kinetic-rqt-top \
    ros-kinetic-rqt-topic \
    ros-kinetic-rqt-web \
    ros-kinetic-rviz-plugin-tutorials \
    ros-kinetic-rviz-python-tutorial \
    ros-kinetic-self-test \
    ros-kinetic-smach \
    ros-kinetic-smach-msgs \
    ros-kinetic-smach-ros \
    ros-kinetic-smclib \
    ros-kinetic-stage \
    ros-kinetic-stage-ros \
    ros-kinetic-stereo-image-proc \
    ros-kinetic-stereo-msgs \
    ros-kinetic-tf-tools \
    ros-kinetic-tf2-eigen \
    ros-kinetic-tf2-geometry-msgs \
    ros-kinetic-tf2-tools \
    ros-kinetic-theora-image-transport \
    ros-kinetic-turtle-actionlib \
    ros-kinetic-turtle-tf \
    ros-kinetic-turtle-tf2 \
    ros-kinetic-turtlesim \
    ros-kinetic-urdf-parser-plugin \
    ros-kinetic-urdf-tutorial \
    ros-kinetic-vision-opencv \
    ros-kinetic-visualization-marker-tutorials \
    ros-kinetic-visualization-tutorials \
    ros-kinetic-viz \
    ros-kinetic-webkit-dependency \
    ros-kinetic-webots-ros

# allow running sudo under non-privileged user in entrypoint script to create, copy and change ownership of files and directories
# should not matter because one is already able to run code inside docker container as root
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers

# Webots config
RUN mkdir -p /root/.config/Cyberbotics
ADD Webots-R2020b.conf /root/.config/Cyberbotics/

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
