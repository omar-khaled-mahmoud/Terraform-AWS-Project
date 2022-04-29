#!/bin/bash


sudo su - root
mkfs.ext4 /dev/sdf
mount -t ext4 /dev/sdf /var/log


yum search nginx 
amazon-linux-extras install nginx1 -y
systemctl start nginx
systemctl enable nginx


sudo echo Hello from `hostname -f` > /usr/share/nginx/html/index.html
