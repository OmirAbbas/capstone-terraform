#!/bin/sh

sudo apt-get update -yy
sudo apt-get install -yy curl

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh

docker volume create my-db
docker run -v my-db:/var/lib/mysql -p 3306:3306 -e MYSQL_USER=user -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=mydatabase -e MYSQL_ROOT_PASSWORD=password --name mysql mysql