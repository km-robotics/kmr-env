#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

docker build \
    -t kmr/env-humble:edge \
    -t ghcr.io/km-robotics/env-humble:edge \
    -f $DIR/Dockerfile \
    $DIR
