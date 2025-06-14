#!/bin/bash
# Використання: bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/storage_synk_stats.sh) 

# Colors
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
CYAN=$'\033[0;36m'
BLUE=$'\033[0;34m'
NC=$'\033[0m'

# Settings
INTERVAL=30
PORT=5678
REMOTE_URL="https://chainscan-galileo.0g.ai/v1/homeDashboard"
ENDPOINT="http://localhost:$PORT"

PREV_LOCAL_BLOCK=0
PREV_TIME=0
FIRST_RUN=true
SYNCED=false

echo -e "${BLUE}📡 Port $PORT monitor started...${NC}"

while true; do
  NOW=$(date '+%H:%M:%S')
  REMOTE=$(curl -s "$REMOTE_URL" | jq -r '.result.blockNumber')

  RESPONSE=$(curl -s -X POST "$ENDPOINT" \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"zgs_getStatus","params":[],"id":1}')

  LOCAL=$(echo "$RESPONSE" | jq -r '.result.logSyncHeight')
  PEERS=$(echo "$RESPONSE" | jq -r '.result.connectedPeers')

  if [[ -z "$REMOTE" || -z "$LOCAL" || "$REMOTE" == "null" || "$LOCAL" == "null" ]]; then
    echo -e "${RED}[$NOW][$PORT] ❌ Data error.${NC}"
    sleep "$INTERVAL"
    continue
  fi

  LEFT=$((REMOTE - LOCAL))

  if (( LEFT > 0 )); then
    OUT="${YELLOW}[$NOW] 🔄 $LEFT ⬇️ (🖥️ $LOCAL / 🌐 $REMOTE) peers: $PEERS"
    SYNCED=false
  else
    if [ "$SYNCED" = false ]; then
      echo -e "${GREEN}[$NOW] ✅ Synced! (🖥️ $LOCAL / 🌐 $REMOTE)${NC}"
      SYNCED=true
    fi
    OUT="${GREEN}[$NOW] 📦 Synced 🖥️ $LOCAL | peers: $PEERS${NC}"
  fi

  if [ "$FIRST_RUN" = false ] && [ "$SYNCED" = false ]; then
    DIFF=$((LOCAL - PREV_LOCAL_BLOCK))
    TDIFF=$(( $(date +%s) - PREV_TIME ))

    if (( TDIFF > 0 && DIFF > 0 )); then
      SPEED=$(echo "scale=2; $DIFF / $TDIFF" | bc)
      ETA=$(echo "scale=0; $LEFT / $SPEED" | bc)
      if (( ETA >= 3600 )); then
        H=$((ETA / 3600))
        M=$(((ETA % 3600) / 60))
        OUT+=" ${CYAN}⏱️ ${H}h ${M}m${NC}"
      elif (( ETA >= 60 )); then
        M=$((ETA / 60))
        S=$((ETA % 60))
        OUT+=" ${CYAN}⏱️ ${M}m ${S}s${NC}"
      else
        OUT+=" ${CYAN}⏱️ ${ETA}s${NC}"
      fi
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
