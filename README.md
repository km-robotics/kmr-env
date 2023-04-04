# KM Robotics development environment

Common images and other tools to standardize development environments used in KM Robotics product development.

## Content

Tools and resources installed in the environment:

* ROS "desktop full"
* Nvidia tools derived from [cudagl Nvidia Docker images](https://hub.docker.com/r/nvidia/cudagl). You may need to install `nvidia-docker2` on the host, cf. https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#install-guide.
* [Webots simulator](https://cyberbotics.com/) in `/opt/webots`

## Docker images

Docker images are placed in [GitHub Container Registry](https://github.com/orgs/km-robotics/packages) and associated with [KM Robotics organization](https://github.com/km-robotics).

Those common environment images and the repository itself are __PUBLIC__.

In the future there should be images for each used ROS version, right now there is support for ROS Kinetic and ROS Noetic and ROS2 Humble.

### Get the image

```bash
docker pull ghcr.io/km-robotics/env-humble:edge
```

**Always** do this before other work, to get newest version of the container image. You can also add `--pull always` argument to `docker run` commands to enforce updating of the Docker image before running.

### Daily work

Suppose that you have your Colcon workspace in `~/robocon_ros2_monows`.

To run single command inside the environment with mapped Colcon workspace and under the same user as in the host system:

```bash
docker run -ti --rm --net=host --device=/dev/dri --env="DISPLAY" -v $HOME/.Xauthority:/$HOME/.Xauthority:rw -v /etc/passwd:/etc/passwd:ro -v /etc/shadow:/etc/shadow:ro -v /etc/group:/etc/group:ro --user $UID -v $HOME/robocon_ros2_monows:$HOME/robocon_ros2_monows -e APP_WS=$HOME/robocon_ros2_monows ghcr.io/km-robotics/env-humble:edge CMD

# add more volume mounts for extra stuff:
# -v $HOME/.config/mc:$HOME/.config/mc -v $HOME/.bashrc:$HOME/.bashrc -v $HOME/.profile:$HOME/.profile -v $HOME/.bash_history:$HOME/.bash_history -v $HOME/.git-credentials:$HOME/.git-credentials -v $HOME/.gitconfig:$HOME/.gitconfig -v $HOME/.config/robocon:$HOME/.config/robocon
```

To start an instance capable of running multiple commands:

```bash
docker run -d -ti --name=kmr1 --net=host --device=/dev/dri --env="DISPLAY" -v $HOME/.Xauthority:/$HOME/.Xauthority:rw -v /etc/passwd:/etc/passwd:ro -v /etc/shadow:/etc/shadow:ro -v /etc/group:/etc/group:ro --user $UID -v $HOME/robocon_ros2_monows:$HOME/robocon_ros2_monows -e APP_WS=$HOME/robocon_ros2_monows ghcr.io/km-robotics/env-humble:edge bash

# in first terminal
docker exec -ti kmr1 bash -l
  . /source_app.sh
  ros2 launch ...

# in second terminal
docker exec -ti kmr1 bash -l
  . /source_app.sh
  rviz2

docker rm -f kmr1
```

To start an environment capable of running multiple commands in several terminals multiplexed by Byobu (command not specified, because `byobu -l -2` is a default command for this image):

```bash
docker run -ti --rm --net=host --device=/dev/dri --env="DISPLAY" -v $HOME/.Xauthority:/$HOME/.Xauthority:rw -v /etc/passwd:/etc/passwd:ro -v /etc/shadow:/etc/shadow:ro -v /etc/group:/etc/group:ro --user $UID -v $HOME/robocon_ros2_monows:$HOME/robocon_ros2_monows -e APP_WS=$HOME/robocon_ros2_monows ghcr.io/km-robotics/env-humble:edge

# open new terminal with F2 or Ctrl+A,C, switch terminals back and forth with F3 or Ctrl+A,P and F4 or Ctrl+A,N, close terminal with Ctrl+A,K; use Esc,number instead of Fnumber in applications such as Midnight Commander
ros2 launch ... # in 1st terminal
rviz2 # in 2nd terminal

# F6 to exit from the environment
```

Of course you can set an alias for those commands by using `alias` command. Persist those aliases in your `.bashrc` file. You can even create Bash functions to create "aliases" with arguments.

### Webots

Webots simulator is installed inside the container in `/opt/webots`. You can run it from inside the container either directly (`/opt/webots/webots`) or by using ROS package `ros-$ROS_DISTRO-webots-ros2`.

### Other useful tools

* [Rocker](https://github.com/osrf/rocker)
* [x11docker](https://github.com/mviereck/x11docker)

## Singularity containers

For easier running of GUI tools and seamless binding with local (host) environment you can also use [Singularity](https://sylabs.io/singularity/) container system.

You can create Singularity image from the Docker image:

```bash
singularity build kmr-env-humble.simg docker://ghcr.io/km-robotics/env-humble:edge
```

Then you can launch something using this image, with your home directory automatically mapped into the container:

```bash
singularity shell kmr-env-humble.simg
  source ...setup.bash
  ros2 launch ... &
  rviz2
  /opt/webots/webots
```

Singularity maps user IDs and automatically maps current user's home directory into the container. The integration is more seamless that way.

> :warning: Problem with Singularity (at least version 2.6.1) is that when you launch something inside the container's shell and then you exit the shell, the thing remains running. That's different from Docker behavior.
