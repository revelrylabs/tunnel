# Run with:
# docker run --rm -p 8080:80 -p 4321:22 tunnel
from alpine:3.12
arg github_token
arg github_org
arg host_keys

run apk update && apk upgrade
run apk add openssh nginx curl sed jq socat logrotate

# This is done on build basically to save time during development
add root/root/fetch_keys.sh /root
run sh /root/fetch_keys.sh ${github_token} ${github_org}

workdir /etc/ssh
run echo $host_keys | base64 -d | zcat | tar x

expose 80 22

copy /root /

workdir /root

cmd ["sh", "/root/boot.sh"]
