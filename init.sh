#!/bin/bash

function makeDataDirectories {
    mkdir $1/data
    mkdir $1/data/moodlewww
    mkdir $1/data/moodledata
    chmod -R 777 $1/data/moodledata
    mkdir $1/data/filescan
}


bold=$(tput bold)
normal=$(tput sgr0)

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPTPATH

echo "${bold}Creating the required directories... ${normal}"
NEWINSTALL=true
if [ -d "$SCRIPTPATH/data" ]; then
    # Control will enter here if directory exists.
    read -p "Data directory exists, delete it? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        rm -rf $SCRIPTPATH/data
        makeDataDirectories $SCRIPTPATH
    else    
        NEWINSTALL=false
    fi
else
    makeDataDirectories $SCRIPTPATH
fi


echo "${bold}Attempting to install the latest version of Moodle via git... ${normal}"
cd $SCRIPTPATH/data/moodlewww

if  [ "$NEWINSTALL" = true ]; then
    git clone https://github.com/moodle/moodle.git .
    git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
else 
    git pull origin master
fi
cd $SCRIPTPATH

echo "${bold}Attempting to install the latest version of the Moodle FileScan block via git... ${normal}"
cd $SCRIPTPATH/data/moodlewww/blocks
if [ "$NEWINSTALL" = true ]; then
    git clone https://github.com/Swarthmore/filescan.git
else 
    git pull origin master
fi
cd $SCRIPTPATH

echo "${bold}Attempting to install the latest version of the Moodle Filescan Server via git... ${normal}"
cd $SCRIPTPATH/data/filescan
if [ "$NEWINSTALL" = true ]; then
    git clone https://github.com/Swarthmore/filescan-server.git .
else 
    git pull origin master
fi
cd $SCRIPTPATH

echo "${bold}Building the docker container... ${normal}"

docker-compose build --no-cache

echo "${bold}Starting the container... ${normal}"

docker-compose up --detach

echo "${bold}Container started in detached state. You can connect to your container using docker exec -it [container name] /bin/bash ${normal}"


# Automatically build Moodle
WEB_CONTAINERNAME="$(docker ps --format "{{.Names}}" --filter status=running |  grep docker-moodle-filescan | grep apache)"
echo $WEB_CONTAINERNAME
if [ "$NEWINSTALL" = true ]; then
    docker exec -it $WEB_CONTAINERNAME sudo -u www-data /usr/local/bin/php  /var/www/html/admin/cli/install.php  --lang=en_us --chmod=2777 --wwwroot=http://localhost --dataroot=/var/www/moodledata --dbtype=mariadb --dbhost=mariadb --dbname=moodle --dbuser=root --dbpass=pepperonisecret --prefix=mdl_ --dbport=3306 --fullname='Filescan Test' --shortname=Filescan --adminuser=admin --adminpass=pepperonisecret --non-interactive --agree-license

    # Configure Moodle 
    # Path to PHP
    docker exec -it $WEB_CONTAINERNAME /usr/local/bin/php /var/www/html/admin/cli/cfg.php --name=pathtophp --set=/usr/local/bin
    # URL for filescan server
    docker exec -it $WEB_CONTAINERNAME /usr/local/bin/php /var/www/html/admin/cli/cfg.php --component=block_filescan --name=apiurl --set=http://filescan-server:9000
    # Timezone
    docker exec -it $WEB_CONTAINERNAME /usr/local/bin/php /var/www/html/admin/cli/cfg.php --name=timezone --set=America/New_York

else
    docker exec -it $WEB_CONTAINERNAME sudo -u www-data /usr/local/bin/php  /var/www/html/admin/cli/upgrade.php  --lang=en_us --non-interactive
fi