#!/bin/bash
set -eu
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMG_NAME="hadoop_test_env"
DOCKER_OPTS=""
for port in 50010 50075 50020 8020 50070 8088 8033 8031
do
    DOCKER_OPTS="${DOCKER_OPTS} -p ${port}:${port}"
done

while getopts "i:v:d:" OPT ; do
  case ${OPT} in
    i)
      IMG_NAME="${OPTARG}"
      ;;
    v)
      VM_NAME="${OPTARG}"
      ;;
    d)
      DOCKER_OPTS="${OPTARG}"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      false
      ;;
  esac
done
eval "$(docker-machine env ${VM_NAME})"
docker build -t ${IMG_NAME} .
docker run ${DOCKER_OPTS} -it ${IMG_NAME}
