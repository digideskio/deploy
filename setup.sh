#!/bin/bash -ex

mkdir -p /yesod-deploy/{bin,etc,incoming,unpacked}
cp angel deploy /yesod-deploy/bin

apt-get install nginx postgresql

cat > /yesod-deploy/etc/angel.conf <<EOF
unpacker {
    exec = "/yesod-deploy/bin/deploy /yesod-deploy/"
}
EOF

cat > /etc/init/yesod-deploy-angel.conf <<EOF
description "Angel process monitoring all deployed applications"
start on runlevel [2345];
stop on runlevel [!2345];
respawn
exec /yesod-deploy/bin/angel /yesod-deploy/etc/angel.conf
EOF

start yesod-deploy-angel
/etc/init.d/nginx start

touch /yesod-deploy/incoming/.trigger
