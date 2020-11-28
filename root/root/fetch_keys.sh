#!/bin/sh

GITHUB_KEY="${1:-$GITHUB_KEY}"
GITHUB_ORG="${2:-$GITHUB_ORG}"

if [[ -z "$GITHUB_KEY" || -z "$GITHUB_ORG" ]]; then
  echo "GITHUB_KEY and GITHUB_ORG must be set"
  exit 1
fi

curl -H "Authorization: Bearer $GITHUB_KEY" \
     -H "Accept: application/vnd.github.v3+json" \
     https://api.github.com/orgs/$GITHUB_ORG/members?per_page=100 > members.json

for username in $(jq -r '.[].login' members.json); do
  home_dir="/home/$username"
  random_password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

  # Users must have a password to login so set a secure random one
  yes $random_password | adduser --shell /bin/false $username
  mkdir $home_dir/.ssh
  curl https://github.com/$username.keys 2> /dev/null > $home_dir/.ssh/authorized_keys
  chmod 600 $home_dir/.ssh/authorized_keys
  chmod 700 $home_dir/.ssh
  chown -R $username:$username $home_dir/.ssh
done
