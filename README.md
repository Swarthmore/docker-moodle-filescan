# Moodle local development docker strategy

## Requirements

[Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

[Docker](https://docs.docker.com/install/)

[Docker compose](https://docs.docker.com/compose/)

## Running
1. `$ git clone https://github.com/tonyweed/docker-moodle-local-dev-strategy.git`
2. `$ cd` into the created directory
3. `$ chmod +x init.sh`
4. `$ ./init.sh`
5. Enjoy!

## Accessing
Moodle: [http://localhost](http://localhost)
Adminer: [http://localhost:8080](http://localhost:8080)

## Environment Variables
You can edit the environment variables in `[mariadb]` `docker-compose.yml`. 

See the [MariaDB docker documentation](https://hub.docker.com/_/mariadb) for available environment variables.
