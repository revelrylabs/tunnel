#!/bin/bash
echo "Starting cron:"
/usr/sbin/crond
echo "Starting nginx:"
/usr/sbin/nginx
echo "Starting sshd:"
/usr/sbin/sshd -D
