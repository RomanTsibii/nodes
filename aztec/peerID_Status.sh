#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/aztec/peerID_Status.sh)

# 1. Try to get peerID from container named 'aztec' using DiscV5 log
peerid=$(sudo docker logs $(docker ps -q --filter "name=aztec" | head -1) 2>&1 | \
  grep -m 1 -ai 'DiscV5 service started' | grep -o '"peerId":"[^"]*"' | cut -d'"' -f4)

# 2. If not found, try any running container with 'aztec' in its image name
if [ -z "$peerid" ]; then
  container_id=$(sudo docker ps --filter "ancestor=$(sudo docker images --format '{{.Repository}}:{{.Tag}}' | grep aztec | head -1)" -q | head -1)
  if [ ! -z "$container_id" ]; then
    peerid=$(sudo docker logs $container_id 2>&1 | \
      grep -m 1 -ai 'DiscV5 service started' | grep -o '"peerId":"[^"]*"' | cut -d'"' -f4)
  fi
fi

# 3. As a last resort, search for any peerId log line in a container with "aztec" in the name
if [ -z "$peerid" ]; then
  peerid=$(sudo docker logs $(docker ps -q --filter "name=aztec" | head -1) 2>&1 | \
    grep -m 1 -ai '"peerId"' | grep -o '"peerId":"[^"]*"' | cut -d'"' -f4)
fi

label=" ● PeerID"
peerline="✓ $peerid"
width=${#peerline}
[ ${#label} -gt $width ] && width=${#label}
line=$(printf '=%.0s' $(seq 1 $width))

if [ -n "$peerid" ]; then
  echo "$line"
  echo -e "$label"
  echo -e "\e[1;32m$peerline\e[0m"
  echo "$line"
  echo

  echo -e "\e[1;34mFetching stats from Nethermind Aztec Explorer...\e[0m"
  response=$(curl -s "https://aztec.nethermind.io/api/peers?page_size=30000&latest=true")

  stats=$(echo "$response" | jq -r --arg peerid "$peerid" '
    .peers[] | select(.id == $peerid) |
    [
      .last_seen,
      .created_at,
      .multi_addresses[0].ip_info[0].country_name,
      .multi_addresses[0].ip_info[0].city_name,
      (.multi_addresses[0].ip_info[0].latitude | tostring),
      (.multi_addresses[0].ip_info[0].longitude | tostring)
    ] | @tsv
  ')

  if [ -n "$stats" ]; then
    IFS=$'\t' read -r last first country city lat lon <<<"$stats"
    last_local=$(date -d "$last" "+%Y-%m-%d - %H:%M" 2>/dev/null || echo "$last")
    first_local=$(date -d "$first" "+%Y-%m-%d - %H:%M" 2>/dev/null || echo "$first")
    printf "%-12s: %s\n" "Last Seen"   "$last_local"
    printf "%-12s: %s\n" "First Seen"  "$first_local"
    printf "%-12s: %s\n" "Country"     "$country"
    printf "%-12s: %s\n" "City"        "$city"
    printf "%-12s: %s\n" "Latitude"    "$lat"
    printf "%-12s: %s\n" "Longitude"   "$lon"
  else
    echo -e "\e[1;31mNo stats found for this PeerID on Nethermind Aztec Explorer.\e[0m"
  fi
else
  echo "No Aztec PeerID found."
fi
