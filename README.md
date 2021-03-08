# KM Robotics development environment

Common images and other tools to standardize development environments used in KM Robotics product development.

## Content

Tools and resources installed in the environment:

* ROS "desktop full"
* Nvidia tools derived from [cudagl Nvidia Docker images](https://hub.docker.com/r/nvidia/cudagl)
* [Webots simulator](https://cyberbotics.com/)

## Docker images

Docker images are placed in [GitHub Container Registry](https://github.com/orgs/km-robotics/packages) and associated with [KM Robotics organization](https://github.com/km-robotics).

Those common environment images and the repository itself are __PUBLIC__.

In the future there should be images for each used ROS version, right now there is support only for ROS Kinetic.

Usage:

```bash
docker pull ghcr.io/km-robotics/env-kinetic:edge
```

To run single command inside the environment:

```bash
docker run -ti --rm ghcr.io/km-robotics/env-kinetic:edge CMD
```

To start an instance capable of running multiple commands and map /home directory into the instance:

```bash
docker run -d -ti --name=kmr1 --net=host --device=.dev/dri --env="DISPLAY" -v $HOME/.Xauthority:/root/.Xauthority:rw -v /home:/home ghcr.io/km-robotics/env-kinetic:edge bash

# in first terminal
docker exec kmr1 bash
  source ...setup.bash
  roscore

# in second terminal
docker exec kmr1 bash
  source ...setup.bash
  rviz

docker rm -f kmr1
```

Or you can open just one shell into the container and use `byobu` there to multiplex the terminal.

> :warning: The problem is that you are running as `root` inside the container and user IDs are not mapped between the host system and the container. Therefore any changes made to the filesystem under /home/... are then problematic back in the host system.

### Other useful tools

* [Rocker](https://github.com/osrf/rocker)
* [x11docker](https://github.com/mviereck/x11docker)

## Singularity containers

For easier running of GUI tools and seamless binding with local (host) environment you can also use [Singularity](https://sylabs.io/singularity/) container system.

You can create Singularity image from the Docker image:

```bash
singularity build kmr-env-kinetic.simg docker://ghcr.io/km-robotics/env-kinetic:edge
```

Then you can launch something using this image, with your home directory automatically mapped into the container:

```bash
singularity shell kmr-env-kinetic.simg
  source ...setup.bash
  roscore &
  rviz
  /opt/webots/webots
```

Singularity maps user IDs and automatically maps current user's home directory into the container. The integration is more seamless that way.

> :warning: Problem with Singularity (at least version 2.6.1) is that when you launch something inside the container's shell and then you exit the shell, the thing remains running. That's different from Docker behavior.
