# SC Docker Environment (dev)
This docker environment provides a base copy of `ros-melodic` along with the following dev repos:
- `rover-simulation`
- `autonomy-packages`
- `husky`
- `ouster_example`

### Installation
- Clone this repo wherever.
- Configure `setup.sh` with the path to your SSH key associated with Space Concordia
- Run `$ bash setup.sh` with root priviledges

### Using the Environment
There are several ways to access the terminal in your docker container:
- Running `$ docker exec -it SC-Robotics /bin/bash` from the host machine
- Attaching VSCode to the container (This also allows you to easily edit source code)
    - Install "Remote - Containers" extension
    - Open the "Remote Explorer" tab, hover over the `ros:melodic SC-Robotics` container, and click "Attach to Container"

To access the volume to edit source code, you can run `$ docker volume inspect --format '{{ .Mountpoint }}' SC-Code` to find the mountpoint, and use the editor of your choice to edit the files. Attaching VSCode to the container does this for you automatically.

### Running GUI Applications
(Linux) To run GUI applications in the container, you must first run `$ xhost +local:docker`. I've heard that this is not a very sEcURe approach, but I think we can live with it for now. Run `$ xhost -local:docker` when you're done.