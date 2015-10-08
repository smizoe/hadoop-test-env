#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMG_NAME="${1:-hadoop_test_env}"
VM_NAME="${2:-dev}"
DOCKER_OPTS="${3}"
eval "$(docker-machine env ${VM_NAME})"
docker build -t ${IMG_NAME} .
docker run ${DOCKER_OPTS} -it --rm  ${IMG_NAME}
