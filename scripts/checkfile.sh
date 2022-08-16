#!/usr/bin/env bash

ssh -i ~/.keys/tux_fanboy.pem ubuntu@3.111.213.79<<EOF
echo "sshed"
echo "checking file"
if [ -f leave_me_here ]; then
    exit
fi

echo "Leaving"

touch left_here
EOF
