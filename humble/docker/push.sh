#!/bin/bash

docker tag kmr/env-humble:edge ghcr.io/km-robotics/env-humble:edge
docker push ghcr.io/km-robotics/env-humble:edge
