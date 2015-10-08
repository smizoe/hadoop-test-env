#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMG_NAME="${1:-hadoop_test_env}"
VM_NAME="${2:-dev}"
eval "$(docker-machine env ${VM_NAME})"
docker build -t ${IMG_NAME} .
docker run -it --rm  ${IMG_NAME}
