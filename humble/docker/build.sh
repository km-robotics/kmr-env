#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

docker build \
    -t kmr/env-humble:edge \
    -f $DIR/Dockerfile \
    $DIR

docker tag kmr/env-humble:edge ghcr.io/km-robotics/env-humble:edge
