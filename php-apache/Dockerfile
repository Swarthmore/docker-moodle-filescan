FROM php:7.2.1-apache

# use the default defvelopment ini
RUN mkdir /usr/src/php
RUN tar --file /usr/src/php.tar.xz --extract --strip-components=1 --directory /usr/src/php
RUN cp /usr/src/php/php.ini-production /usr/local/etc/php/php.ini

# Fix bad proxy? Seems like a Docker bug
# https://forums.docker.com/t/hash-sum-mismatch-writing-more-data-as-expected/45940/2

COPY ./badproxyfix /etc/apt/apt.conf.d/99-badproxyfix

# Ask apt server to provide uncached files
RUN apt -o Acquire::https::No-Cache=True -o Acquire::http::No-Cache=True update
RUN apt-get update
RUN apt-get -y upgrade

# Install moodle php dependencies
RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN apt-get install -y libzip-dev sendmail libpng-dev libicu-dev apt-utils re2c g++ zlib1g-dev libmcrypt-dev libxml2-dev 
RUN apt-get clean
RUN docker-php-ext-configure mbstring && docker-php-ext-install mbstring
RUN docker-php-ext-configure zip --with-libzip && docker-php-ext-install zip
RUN docker-php-ext-configure gd && docker-php-ext-install gd
RUN docker-php-ext-configure intl && docker-php-ext-install intl
RUN docker-php-ext-configure soap && docker-php-ext-install soap
RUN docker-php-ext-configure xmlrpc && docker-php-ext-install xmlrpc
RUN docker-php-ext-install opcache

# Use opcache for improved performance
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini
