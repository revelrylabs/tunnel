#!/bin/bash
echo "Starting nginx:"
/usr/sbin/nginx
echo "Starting sshd:"
/usr/sbin/sshd -D

