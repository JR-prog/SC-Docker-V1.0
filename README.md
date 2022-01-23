# SC Docker Environment (dev)
This docker environment provides a base copy of `ros-melodic` along with the following dev repos:
- `rover-simulation`
- `autonomy-packages`
- `husky`
- `ouster_example`
*For now, this setup doesn't work on Windows*

### Pre-installation
If you already have your space concordia SSH key setup, you can ignore this section.
For this to work properly, you will need to have an SSH key for github on your device, to set this up you must:
- run `$ ssh-keygen -t ed25519 -C "your_email@spaceconcordia.com"` (make sure this email is added to the Space Concordia organization on GitHub)
- run `$ cat ~/.ssh/id_ed25519.pub` and copy the output to your clipboard ***except the email at the end***
- log in to GitHub and go to https://github.com/settings/keys 
- click "New SSH key", give it a title (like the name of your device), and paste the ssh key. Finish by clicking "Add SSH key"

### Installation
- Clone this repo wherever.
- Configure `setup.sh` with the path to your SSH key associated with Space Concordia
- Run `$ sudo bash setup.sh`

### Using the Environment
There are several ways to access the terminal in your docker container:
- Running `$ docker exec -it SC-Robotics /bin/bash` from the host machine
- Attaching VSCode to the container (This also allows you to easily edit source code)
    - Install "Remote - Containers" extension
    - Open the "Remote Explorer" tab, hover over the `ros:melodic SC-Robotics` container, and click "Attach to Container"

To access the volume to edit source code, you can run `$ docker volume inspect --format '{{ .Mountpoint }}' SC-Code` to find the mountpoint, and use the editor of your choice to edit the files. Attaching VSCode to the container does this for you automatically.

### Running GUI Applications
(Linux) To run GUI applications in the container, you must first run `$ xhost +local:docker`. I've heard that this is not a very sEcURe approach, but I think we can live with it for now. Run `$ xhost -local:docker` when you're done.