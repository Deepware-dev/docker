#sudo docker run --gpus all --tty --interactive --network=host --env DISPLAY=:0 --volume="$XAUTH:/root/.Xauthority" -ti deepwaredev/deep-image

docker run -it \
    --gpus all \
    --network=host \
    --tty --interactive \
    --user=$USER \
    --env="DISPLAY" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    deepwaredev/deep-image
