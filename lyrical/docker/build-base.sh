#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

docker build \
    -t kmr/env-lyrical-base:edge \
    -t ghcr.io/km-robotics/env-lyrical-base:edge \
    -f "$DIR/Dockerfile.base" \
    "$DIR"
