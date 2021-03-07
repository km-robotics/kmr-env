FROM osrf/ros:kinetic-desktop-full

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

RUN apt update && apt install -y wget curl htop iotop iftop tcpdump byobu mc

# Webots dependencies
# from https://github.com/cyberbotics/webots-docker/blob/master/Dockerfile
RUN wget https://raw.githubusercontent.com/cyberbotics/webots/master/scripts/install/linux_runtime_dependencies.sh
RUN chmod +x linux_runtime_dependencies.sh && ./linux_runtime_dependencies.sh && rm ./linux_runtime_dependencies.sh

# Webots
RUN wget -O webots.tar.bz2 "https://github.com/cyberbotics/webots/releases/download/R2020b-rev1/webots-R2020b-rev1-x86-64_ubuntu-16.04.tar.bz2"
RUN tar -xjf webots.tar.bz2 -C /opt && rm -rf webots.tar.gz
ENV WEBOTS_HOME=/opt/webots
ENV QTWEBENGINE_DISABLE_SANDBOX=1

# Install X virtual framebuffer to be able to use Webots without GPU and GUI (e.g. CI)
RUN apt update && apt install --yes xvfb

# ROS packages
RUN apt install -y \
ros-kinetic-actionlib-tutorials \
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
ros-kinetic-pcl-ros \
ros-kinetic-joy \
ros-kinetic-webots-ros \
ros-kinetic-ifm3d \
liborocos-kdl-dev

# cleanup
RUN rm -rf /var/lib/apt/lists/

CMD ["/bin/bash"]
