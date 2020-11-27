# Run with:
# docker run --rm -p 8080:80 -p 4321:22 tunnel
from alpine:3.12
arg github_token

run apk update && apk upgrade
run apk add openssh nginx curl sed jq

add fetch_keys.sh .
run sh fetch_keys.sh ${github_token}

workdir /etc/ssh
run ssh-keygen -A

copy /root /

run nginx

run mkdir /tunnel
run chmod 777 /tunnel

expose 80 22

cmd ["sh", "/root/run_servers.sh"]
