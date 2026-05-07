#!/bin/bash

docker tag kmr/env-humble-base:edge ghcr.io/km-robotics/env-humble-base:edge
docker push ghcr.io/km-robotics/env-humble-base:edge
