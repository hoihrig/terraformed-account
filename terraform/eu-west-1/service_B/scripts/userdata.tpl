#!/bin/bash

sudo apt-get -y update
sudo apt-get -y install nginx
sudo service nginx start

public_ip=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
public_dns=`curl http://169.254.169.254/latest/meta-data/public-hostname`
echo $public_ip > /var/www/html/index.html
echo $public_dns >> /var/www/html/index.html