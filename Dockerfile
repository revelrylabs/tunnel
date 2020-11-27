# Run with:
# docker run -p 4321:22 tunnel
from alpine:3.12
arg github_token

run apk update && apk upgrade
run apk add openssh nginx curl sed jq

#add nginx.conf /etc/nginx/nginx.conf
add fetch_keys.sh .
run sh fetch_keys.sh ${github_token}

workdir /etc/ssh
run ssh-keygen -A
add sshd_config .

add motd /etc/motd

expose 22

cmd ["/usr/sbin/sshd","-D"]
