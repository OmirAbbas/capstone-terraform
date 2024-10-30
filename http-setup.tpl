#!/bin/sh

sudo apt-get update -yy
sudo apt-get install -yy curl

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh

docker pull omirabbas/capstone-project
docker run -p 80:5000 -e "REDIS_HOST=${redis_host}" -e "DB_HOST=${db_host}" --name web omirabbas/capstone-project
