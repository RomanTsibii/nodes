#!/bin/bash
# Використання: bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/storage_synk_stats.sh) 
# Colors
# === Кольори ===
RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[1;33m'
CYAN=$'\033[0;36m'; BLUE=$'\033[0;34m'; MAGENTA=$'\033[0;35m'; NC=$'\033[0m'

# === Параметри ===
if [ -n "$1" ]; then
    INTERVAL=$1
else
    INTERVAL=30
fi

PORT=5678
REMOTE_URL="https://chainscan-galileo.0g.ai/v1/homeDashboard"
ENDPOINT="http://localhost:$PORT"
NODE_DIR="/root/0g-storage-node"
DB_DIR="$NODE_DIR/run/db"
SIZE_FILE="/tmp/.db_size_tracker"

# === Стартові змінні ===
PREV_LOCAL_BLOCK=0
PREV_TIME=0
FIRST_RUN=true
SYNCED=false

echo -e "${BLUE}📡 Port $PORT monitor started. Checking every $INTERVAL sec...${NC}"

while true; do
  NOW=$(date '+%H:%M:%S')

  REMOTE_RAW=$(curl -s --max-time 5 "$REMOTE_URL")
  RESPONSE_RAW=$(curl -s --max-time 5 -X POST "$ENDPOINT" \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"zgs_getStatus","params":[],"id":1}')

  if ! echo "$REMOTE_RAW" | jq -e . >/dev/null 2>&1 || ! echo "$RESPONSE_RAW" | jq -e . >/dev/null 2>&1; then
    echo -e "${RED}[$NOW][$PORT] ⚠️  Node/remote unreachable or invalid response. Retrying...${NC}"
    sleep "$INTERVAL"; continue
  fi

  REMOTE=$(echo "$REMOTE_RAW" | jq -r '.result.blockNumber // empty')
  LOCAL=$(echo "$RESPONSE_RAW" | jq -r '.result.logSyncHeight // empty')
  PEERS=$(echo "$RESPONSE_RAW" | jq -r '.result.connectedPeers // 0')

  if [[ -z "$REMOTE" || -z "$LOCAL" || "$REMOTE" == "null" || "$LOCAL" == "null" ]]; then
    echo -e "${RED}[$NOW][$PORT] ❌ Data fetch failed (block info null).${NC}"
    sleep "$INTERVAL"; continue
  fi

  CURRENT_DB_MB=$(du -sm "$DB_DIR" 2>/dev/null | cut -f1)
  NODE_SIZE_MB=$(du -sm "$NODE_DIR" 2>/dev/null | cut -f1)

  DB_CHANGE="${CYAN}➖ 0 MB${NC}"
  if [[ -n "$CURRENT_DB_MB" ]]; then
    if [ -f "$SIZE_FILE" ]; then
      PREV_DB_MB=$(cat "$SIZE_FILE")
      DB_DIFF=$((CURRENT_DB_MB - PREV_DB_MB))
      if (( DB_DIFF > 0 )); then
        DB_CHANGE="${RED}📈 +${DB_DIFF} MB${NC}"
      elif (( DB_DIFF < 0 )); then
        DB_CHANGE="${GREEN}📉 $(( -1 * DB_DIFF )) MB${NC}"
      fi
    fi
    echo "$CURRENT_DB_MB" > "$SIZE_FILE"
  fi

  LEFT=$((REMOTE - LOCAL))
  SPEED_INFO=""; ETA_STR=""; BLOCKS_PER_SEC=""

  if [ "$FIRST_RUN" = false ]; then
    CURRENT_TIME=$(date +%s)
    BLOCK_DIFF=$((LOCAL - PREV_LOCAL_BLOCK))
    TIME_DIFF=$((CURRENT_TIME - PREV_TIME))
    if (( TIME_DIFF > 0 )); then
      BLOCKS_PER_SEC=$(echo "scale=2; $BLOCK_DIFF / $TIME_DIFF" | bc)
      SPEED_INFO=" ${MAGENTA}⚡️ ${BLOCKS_PER_SEC} bl/s${NC}"
      if (( $(echo "$BLOCKS_PER_SEC > 0" | bc -l) )) && (( LEFT > 0 )); then
        ETA=$(echo "scale=0; $LEFT / $BLOCKS_PER_SEC" | bc 2>/dev/null || echo "0")
        if (( ETA >= 3600 )); then
          H=$((ETA / 3600)); M=$(((ETA % 3600) / 60))
          ETA_STR=" ${CYAN}⏱️ ${H}h ${M}m${NC}"
        elif (( ETA >= 60 )); then
          M=$((ETA / 60)); S=$((ETA % 60))
          ETA_STR=" ${CYAN}⏱️ ${M}m ${S}s${NC}"
        else
          ETA_STR=" ${CYAN}⏱️ ${ETA}s${NC}"
        fi
      fi
    fi
  fi

  # --- Форматований вивід — завжди один рядок
  echo -e "[$NOW] 🔄 $LEFT ⬇️ (🖥 $LOCAL / 🌐 $REMOTE) peers: $PEERS$SPEED_INFO $DB_CHANGE$ETA_STR  ${CYAN}📂 node size: ${NODE_SIZE_MB:-0} MB${NC}"

  PREV_LOCAL_BLOCK=$LOCAL
  PREV_TIME=$(date +%s)
  FIRST_RUN=false

  sleep "$INTERVAL"
done
