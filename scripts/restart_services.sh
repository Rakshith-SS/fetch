#!/usr/bin/env bash

# Usage
# ./restart_services.sh <SERVER> <REPO_URL> <REPO_CREDENTIAL> <REPO_NAME>

# 1. ssh into server
# 2. git pull
# 3. restart_services

SERVER=3.108.64.155
KEY="django_test.pem"

REPO_NAME=$1

ssh -i ~/.keys/$KEY ubuntu@$SERVER<<EOF

cd /home/ubuntu/$REPO_NAME

echo "Perfoming git pull"
git pull
echo "Successfully fetched files"

echo "Restarting nginx and supervisor"
sudo supervisorctl stop $REPO_NAME
sudo supervisorctl start $REPO_NAME
sudo systemctl restart nginx
echo "Successfully restarted nginx and supervisor"

EOF
