#!/bin/bash

function error {
  echo -e "\\e[91m$1\\e[39m"
  exit 1
}

function check_internet() {
  printf "Checking if you are online..."
  wget -q --spider http://github.com
  if [ $? -eq 0 ]; then
    echo "Internet Connection. OK"
  else
    error "Internet Connection. FAIL. Please Verify it."
  fi
}

check_internet

cd "portainer"
docker-compose up -d portainer/portainer-ce:latest || error "Failed to create and run Portainer docker image!"
