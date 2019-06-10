FROM node:latest

RUN apt-get update && apt-get -y install git

WORKDIR /usr/src

# RUN git clone https://github.com/Swarthmore/filescan-server.git

#RUN cd filescan-server

# RUN npm install

#WORKDIR /usr/src/filescan-server

# Set node port to use 9000 to avoid conflict with adminer
ENV PORT=9000

# CMD [ "npm", "start"]