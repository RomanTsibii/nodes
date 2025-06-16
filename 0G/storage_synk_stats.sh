#!/bin/bash
# Використання: bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/storage_synk_stats.sh) 
# Colors
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
CYAN=$'\033[0;36m'
BLUE=$'\033[0;34m'
MAGENTA=$'\033[0;35m'
NC=$'\033[0m'

# Settings
# INTERVAL=${INTERVAL:-30}
if [ -n "$1" ]; then
    INTERVAL=$1
else
    INTERVAL=30
fi

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
  
  # Отримуємо дані
  REMOTE=$(curl -s "$REMOTE_URL" | jq -r '.result.blockNumber')
  RESPONSE=$(curl -s -X POST "$ENDPOINT" \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"zgs_getStatus","params":[],"id":1}')
  
  LOCAL=$(echo "$RESPONSE" | jq -r '.result.logSyncHeight')
  PEERS=$(echo "$RESPONSE" | jq -r '.result.connectedPeers')
  
  # Перевіряємо на помилки
  if [[ -z "$REMOTE" || -z "$LOCAL" || "$REMOTE" == "null" || "$LOCAL" == "null" ]]; then
    echo -e "${RED}[$NOW][$PORT] ❌ Data error.${NC}"
    sleep "$INTERVAL"
    continue
  fi
  
  LEFT=$((REMOTE - LOCAL))
  
  # Розраховуємо швидкість синхронізації
  SPEED_INFO=""
  if [ "$FIRST_RUN" = false ]; then
    CURRENT_TIME=$(date +%s)
    BLOCK_DIFF=$((LOCAL - PREV_LOCAL_BLOCK))
    TIME_DIFF=$((CURRENT_TIME - PREV_TIME))
    
    if (( TIME_DIFF > 0 )); then
      BLOCKS_PER_SEC=$(echo "scale=2; $BLOCK_DIFF / $TIME_DIFF" | bc)
      if (( $(echo "$BLOCKS_PER_SEC > 0" | bc -l) )); then
        SPEED_INFO=" ${MAGENTA}⚡ ${BLOCKS_PER_SEC} bl/s${NC}"
      fi
    fi
  fi
  
  if (( LEFT > 0 )); then
    OUT="${YELLOW}[$NOW] 🔄 $LEFT ⬇️ (🖥️ $LOCAL / 🌐 $REMOTE) peers: $PEERS${SPEED_INFO}"
    SYNCED=false
    
    # Розраховуємо ETA якщо маємо швидкість
    if [ "$FIRST_RUN" = false ] && [ -n "$SPEED_INFO" ]; then
      DIFF=$((LOCAL - PREV_LOCAL_BLOCK))
      TDIFF=$(( $(date +%s) - PREV_TIME ))
      
      if (( TDIFF > 0 && DIFF > 0 )); then
        SPEED=$(echo "scale=2; $DIFF / $TDIFF" | bc)
        if (( $(echo "$SPEED > 0" | bc -l) )); then
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
        fi
      else
        OUT+=" ${CYAN}⚡ Estimating...${NC}"
      fi
    fi
  else
    if [ "$SYNCED" = false ]; then
      echo -e "${GREEN}[$NOW] ✅ Synced! (🖥️ $LOCAL / 🌐 $REMOTE)${NC}"
      SYNCED=true
    fi
    OUT="${GREEN}[$NOW] 📦 Synced 🖥️ $LOCAL | peers: $PEERS${SPEED_INFO}${NC}"
  fi
  
  echo -e "$OUT"
  
  # Зберігаємо дані для наступної ітерації
  PREV_LOCAL_BLOCK=$LOCAL
  PREV_TIME=$(date +%s)
  FIRST_RUN=false
  
  sleep "$INTERVAL"
done
