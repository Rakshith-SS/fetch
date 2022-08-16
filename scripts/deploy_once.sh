#!/usr/bin/env bash

# run it as ./scripts/deploy_once.sh <SERVER IP> <DOMAIN NAME> <REPO_NAME> <REPO_URL> <Git Credential Token>
# Declare REPO_NAME and server as
# command line argument


if [[ $2 -eq 1 ]]; then
   SERVER=3.111.213.79
   KEY="tux_fanboy.pem"
fi

REPO_NAME=fetch
REPO_URL=https://github.com/Rakshith-SS/fetch.git

DATABASE=randb1
PASSWORD=passworderg
USERNAME=randur2



ssh -T -i ~/.keys/$KEY ubuntu@$SERVER <<EOF

echo "Setting up postgres"
sudo su - postgres
psql -c "CREATE DATABASE $DATABASE";
psql -c "CREATE USER $USERNAME WITH password '$PASSWORD'";
psql -c "ALTER ROLE $USERNAME SET client_encoding TO 'utf8'";
psql -c "ALTER ROLE $USERNAME SET default_transaction_isolation TO 'read committed'";
psql -c "ALTER ROLE $USERNAME SET timezone TO 'UTC'";
psql -c "GRANT ALL PRIVILEGES ON DATABASE $DATABASE TO $USERNAME";

echo "Successfully CREATED DATABASE $DATABASE"
echo "Successfully created USER $USERNAME"
echo "gamedb PASSWORD - $PASSWORD"

exit


echo "Cloning the Repo"
git clone $REPO_URL


cd /home/ubuntu/$REPO_NAME

touch .env
tee -a .env <<'eof'
ALLOWED_HOST_IP=$SERVER
DB_PASSWORD=$PASSWORD
DB_NAME=$DATABASE
DB_USER=$USERNAME
DB_HOST=localhost
DB_PORT=5432
eof


python3 -m venv env
/home/ubuntu/$REPO_NAME/env/bin/python3 -m pip install -r /home/ubuntu/$REPO_NAME/requirements.txt
/home/ubuntu/$REPO_NAME/env/bin/python3 manage.py collectstatic
sudo chown -R :www-data /home/ubuntu/$REPO_NAME/static


echo "Configuring Supervisor"

sudo touch /etc/supervisor/conf.d/$REPO_NAME.conf
sudo mkdir /var/log/$REPO_NAME
sudo touch /var/log/$REPO_NAME/$REPO_NAME.err.log
sudo touch /var/log/$REPO_NAME/$REPO_NAME.out.log

sudo tee -a /etc/supervisor/conf.d/$REPO_NAME.conf << 'eof'
[program:$REPO_NAME]
directory=/home/ubuntu/$REPO_NAME
command=/home/ubuntu/$REPO_NAME/env/bin/gunicorn $REPO_NAME.wsgi --bind localhost:8000
autostart=true
autorestart=true
stderr_logfile=/var/log/$REPO_NAME/$REPO_NAME.err.log
stdout_file=/var/log/$REPO_NAME/$REPO_NAME.out.log
eof

sudo supervisorctl reread
sudo service supervisor restart

echo "Configured supervisor successfully"

echo "Configuring nginx server"

sudo touch /etc/nginx/sites-available/$REPO_NAME
sudo touch /var/log/nginx/$REPO_NAME.log
sudo touch /var/log/nginx/$REPO_NAME.err.log

sudo tee -a /etc/nginx/sites-available/$REPO_NAME<<'eof'
access_log      /var/log/nginx/$REPO_NAME.log;
error_log       /var/log/nginx/$REPO_NAME.err.log;

server{
    listen          80;
    server_name     $SERVER;
    charset         utf-8;
    root            /home/ubuntu/$REPO_NAME;

    client_max_body_size   75M;

    location = /favicon.ico { access_log off; log_not_found off; }

    location /static/ {
        autoindex on;
        alias /home/ubuntu/$REPO_NAME/static/;
    }

    location / {
        include         proxy_params;
        proxy_pass      http://localhost:8000;
    }


}
eof

sudo ln -s /etc/nginx/sites-available/$REPO_NAME /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

EOF
