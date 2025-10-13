#! /bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -r WORKDIR -d HOMEDIR -i DOCKER_REPO -n CONTAINER_NAME -c COMMAND"
   echo -e "\t-r working directory on host"
   echo -e "\t-d working directory in container"
   echo -e "\t-i docker repo"
   echo -e "\t-n containe name"
   echo -e "\t-c command"
   exit 1 # Exit script after printing help
}

while getopts "r:d:i:n:c" opt
do
   case "$opt" in
      r ) WORKDIR="$OPTARG" ;;
      d ) HOMEDIR="$OPTARG" ;;
      i ) DOCKER_REPO="$OPTARG" ;;
      n ) CONTAINER_NAME="$OPTARG" ;;
      c ) COMMAND="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# give default options:
if [ -z ${WORKDIR+x} ]; then
	WORKDIR="$(pwd)"
else
	echo "WORKDIR is set to '$WORKDIR'";
fi

if [ -z ${HOMEDIR+x} ]; then
	HOMEDIR="workdir"
else
	echo "HOMEDIR is set to '$HOMEDIR'";
fi

if [ -z ${COMMAND+x} ]; then
	COMMAND="bash"
else
	echo "COMMAND is set to '$COMMAND'";
fi

# Print helpFunction in case parameters are empty
if [ -z "$DOCKER_REPO" ] || [ -z "$CONTAINER_NAME" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# enable access to xhost from the container
# be carefull, this command exposes your machine and makes sure that anyone can connect to it [https://www.baeldung.com/linux/docker-container-gui-applications].
# xhost +

# Thus, it’s better to specify the source of the connections that we want.
xhost +local:docker

# docker hygiene

#Delete all stopped containers (including data-only containers)
#docker rm $(docker ps -a -q)

#Delete all 'untagged/dangling' (<none>) images
#docker rmi $(docker images -q -f dangling=true)

echo "DOCKER_REPO: $DOCKER_REPO";

CCACHE_DIR=${HOME}/.ccache
# mkdir -p "${CCACHE_DIR}"

XAUTH=/tmp/.docker.xauth

docker run -it --rm --privileged --gpus all \
--env=LOCAL_USER_ID="$(id -u)" \
--env=CCACHE_DIR="${CCACHE_DIR}" \
-v ${CCACHE_DIR}:${CCACHE_DIR}:rw \
-v /tmp/.X11-unix:/tmp/.X11-unix/:rw \
-v $XAUTH:$XAUTH \
-v $WORKDIR:$HOMEDIR \
-v /dev:/dev/ \
-w $HOMEDIR \
-e DISPLAY=$DISPLAY \
-e NVIDIA_VISIBLE_DEVICES=all \
-e NVIDIA_DRIVER_CAPABILITIES=all \
-e QT_X11_NO_MITSHM=1 \
--network=host \
-u user \
--name=${CONTAINER_NAME} ${DOCKER_REPO} ${COMMAND}