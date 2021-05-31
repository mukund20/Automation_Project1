#!/bin/bash

myname=mukund

timestamp=$(date '+%d%m%Y-%H%M%S')

s3_bucket=upgrad-mukund

echo  -e  "\t\t\t\t\e[32m <=========Updating Packeages===========>\e[0m\t"

sudo apt update -y


echo  -e  "\t\t\t\t\e[32m <=========Installing Web Server===========>\e[0m\t"

apt list --installed | grep "apache2"

if [ $? -eq 0 ];then

        echo -e  "\e[32m Already installed\e[0m "
else
        sudo apt-get install apache2 -y
fi

echo  -e  " \t\t\t\t\e[32m <=========Checking web server is running or not===========>\e[0m\t"

ps cax | grep apache2
if [ $? -eq 0 ]; then
	echo -e " \e[32mApache2 is running\e[0m"
else
	sudo systemctl restart apache2
	echo  -e  " \e[31mApache2 service not started\e[0m \e[0m Starting Apache....\e[0m \e[32mApache2 started\e[0m"

fi
echo  -e  " \t\t\t\t\e[32m <=========Web Server Status===========>\e[0m\t"


sudo systemctl status apache2

echo  -e  " \t\t\t\t\e[32m <=========Enabling Apache2 service===========>\e[0m\t"

sudo systemctl enable apache2

echo  -e  "\t\t\t\t\e[32m <=========Exporting logs to AWS S3 bucket===========>\e[0m\t"

cd /var/log/apache2

tar -cvf /tmp/$myname-httpd-logs-$timestamp.tar access.log error.log

aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

