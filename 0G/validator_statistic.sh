#!/bin/bash
# Використання: bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/validator_statistic.sh) 

# Colors
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
CYAN=$'\033[0;36m'
NC=$'\033[0m'

INTERVAL=30
REMOTE_URL="https://chainscan-galileo.0g.ai/v1/homeDashboard"
PREV_LOCAL_BLOCK=0
PREV_TIME=0
FIRST_RUN=true

while true; do
  NOW=$(date '+%H:%M:%S')
  REMOTE=$(curl -s "$REMOTE_URL" | jq -r '.result.blockNumber')
  LOCAL=$(curl -s http://localhost:26657/status | jq -r '.result.sync_info.latest_block_height')
  PEERS=$(curl -s http://localhost:26657/net_info | jq -r '.result.n_peers')

  if [[ -z "$REMOTE" || -z "$LOCAL" || "$REMOTE" == "null" || "$LOCAL" == "null" ]]; then
    echo -e "${RED}[$NOW] ❌ Error fetching blocks${NC}"
    sleep "$INTERVAL"
    continue
  fi

  LEFT=$((REMOTE - LOCAL))

  if (( LEFT > 0 )); then
    OUT="${YELLOW}[$NOW] 🔄 $LEFT blocks ⬇️ (🖥️ $LOCAL / 🌐 $REMOTE) peers: $PEERS"
  else
    OUT="${GREEN}[$NOW] ✅ Sync done! (🖥️ $LOCAL / 🌐 $REMOTE) peers: $PEERS${NC}"
  fi

  if [ "$FIRST_RUN" = false ]; then
    DIFF=$((LOCAL - PREV_LOCAL_BLOCK))
    TDIFF=$(( $(date +%s) - PREV_TIME ))

    if (( TDIFF > 0 && DIFF > 0 )); then
      SPEED=$(echo "scale=2; $DIFF / $TDIFF" | bc)
      ETA=$(echo "scale=0; $LEFT / $SPEED" | bc)
      HM=$((ETA / 60)); HS=$((ETA % 60))
      OUT+=" ${CYAN}⏱️ ${HM}m ${HS}s${NC}"
    else
      OUT+=" ${CYAN}⚡ Estimating...${NC}"
    fi
  else
    FIRST_RUN=false
  fi

  echo -e "$OUT"

  PREV_LOCAL_BLOCK=$LOCAL
  PREV_TIME=$(date +%s)
  sleep "$INTERVAL"
done

