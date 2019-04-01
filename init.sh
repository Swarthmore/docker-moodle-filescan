#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)


echo "${bold}Creating the required diretories... ${normal}"

mkdir moodlewww
mkdir moodledata
chmod -R 777 moodledata

echo "${bold}Attempting to install the latest version of Moodle via git... ${normal}"
cd moodlewww
git clone https://github.com/moodle/moodle.git .
git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
cd ..

echo "${bold}Building the docker container... ${normal}"

docker-compose build --no-cache

echo "${bold}Starting the container... ${normal}"

docker-compose up --detach

echo "${bold}Container started in detached state. You can connect to your container using docker exec -it [container name] /bin/bash ${normal}"
