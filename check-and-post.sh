#!/bin/sh
sleep 10
cd /var/www/fftr-webhooks/check-dublicates
./check-dublicates.sh | ruby irc.rb > /dev/null 2>&1
