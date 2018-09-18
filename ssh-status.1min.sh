#!/usr/bin/env bash
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
