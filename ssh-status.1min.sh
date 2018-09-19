#!/usr/bin/env bash
# <bitbar.title>SSH Status</bitbar.title>
# <bitbar.version>v0.2.0</bitbar.version>
# <bitbar.author>Keno Oelrichs Garcia</bitbar.author>
# <bitbar.author.github>MrDrache333</bitbar.author.github>
# <bitbar.image>http://i.imgur.com/s8FMCLG.png</bitbar.image>
# <bitbar.desc>Continuously checks if hosts are available for ssh connection</bitbar.desc>
# <bitbar.dependencies>Bash</bitbar.dependencies>
#
# SSH Status plugin
# by Keno Oelrichs Garcia (@Kenoog)
# THIS PROGRAM IN ITS FIRST VERSION WAS ORIGINALLY WRITTEN BY @oliviernt
#
# Continuously checks if hosts are available for ssh connection on port 22
#HOSTS are the HOSTS you want to look for
HOSTS=("raspberrypi.local" "example.com")
#USERS are the Usernames to login with if you klick on the Host
USERS=("pi" "Admin")
#Used Language
LANG="DE"

#Languages
EN=("is up" "is down")
DE=("ist erreichbar" "ist nicht erreichbar")

if [[ "$LANG" = "DE" ]]; then
  LANG=$DE
elif [[ "$LANG" = "EN" ]]; then
    LANG=$EN
fi

head="SSH"
body=""
reachable=0
for (( i = 0; i < ${#HOSTS[@]}; i++ )); do
  host=${HOSTS[i]}
  if nc -z -G 2 "$host" 22 &> /dev/null; then
    body="$body\n✅ $host ${LANG[0]} | color=green bash=ssh param1=${USERS[i]}@$host"
    reachable=$((reachable +1))
  else
    body="$body\n❌ $host ${LANG[1]} | color=red bash=ssh param1=${USERS[i]}@$host"
  fi
  body="$body\n---"
done

echo -n "$head"
  if [[ "$reachable" -eq 0 ]]; then
    echo -n " (0/${#HOSTS[@]}) | color=red"
  elif [[ "$reachable" = "${#HOSTS[@]}" ]]; then
    echo -n " (${#HOSTS[@]}/${#HOSTS[@]}) | color=green"
  elif [[ "$reachable" -gt 0 ]]; then
    echo -n " ($((reachable))/${#HOSTS[@]}) | color=orange"
  fi
echo -e "\n---"
echo -e "$body"
