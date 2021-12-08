#!/bin/sh

# Put the path to your ssh key here
sshpath="~/.ssh/id_ed25519"

thisdir=$(pwd)

# Creating container and volume
docker image build .
docker volume create SC-Code
docker run -dt --name SC-Robotics --restart unless-stopped --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --volume="$HOME/.Xauthority:/root/.Xauthority" --mount source=SC-Code,target=/root/ ros:melodic
# Running required commands in container (for some reason these do not work when added to dockerfile?)
docker exec -it SC-Robotics apt update
docker exec -it SC-Robotics apt install -y python3-pip
docker exec -it SC-Robotics pip3 install -U rosdep rosinstall_generator wstool rosinstall six vcstools

# Configuring the volume
volumedir=$(docker volume inspect --format '{{ .Mountpoint }}' SC-Code)
cd $volumedir
echo "source /opt/ros/melodic/setup.bash" >> .bashrc
echo "source /root/catkin_ws/devel/setup.bash" >> .bashrc
# The following is only because husky is in this env, can remove for other envs
echo "export HUSKY_GAZEBO_DESCRIPTION=$(rospack find husky_gazebo)/urdf/description.gazebo.xacro" >> .bashrc

mkdir -p catkin_ws/src
docker exec -it SC-Robotics bash -c "cd /root/catkin_ws/ ; 
source /opt/ros/melodic/setup.bash ; 
catkin_make -DPYTHON_EXECUTABLE=/usr/bin/python3"

# Add the required stuff for ssh
docker exec -it SC-Robotics apt-get -y install openssh-server
cp -r ~/.ssh "$volumedir/"

# Confirm ssh (not strictly necessary)
docker exec -it SC-Robotics ssh -T git@github.com 

# Clone repos
docker exec -it SC-Robotics bash -c "cd /root/catkin_ws/src ; 
git clone git@github.com:space-concordia-robotics/rover-simulation.git ;
git clone git@github.com:space-concordia-robotics/autonomy-packages.git ;
git clone git@github.com:space-concordia-robotics/husky.git ;
git clone git@github.com:space-concordia-robotics/ouster_example.git"

# Install dependencies
docker exec -it SC-Robotics rosdep install --from-paths /root/catkin_ws/src --ignore-src -r -y
