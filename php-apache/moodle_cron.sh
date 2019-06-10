#!/usr/bin/env bash

# Ensure the log file exists
touch /var/log/cron.log


# Added a cronjob in a new crontab
echo "*/1 * * * * /usr/local/bin/php  /var/www/html/admin/cli/cron.php >> /var/log/cron.log 2>&1" > /etc/cron.d/crontab

# Registering the new crontab
crontab /etc/cron.d/crontab

# Starting the cron
/usr/sbin/service cron start

# Displaying logs
# Useful when executing docker-compose logs mycron
tail -f /var/log/cron.log