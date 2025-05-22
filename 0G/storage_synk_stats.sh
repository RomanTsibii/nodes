#!/bin/bash
# Використання: bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/storage_synk_stats.sh) 

# Кольори
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
CYAN=$'\033[0;36m'
BLUE=$'\033[0;34m'
NC=$'\033[0m'

# Налаштування
INTERVAL=30
PORT=5678
REMOTE_URL="https://chainscan-galileo.0g.ai/v1/homeDashboard"
ENDPOINT="http://localhost:$PORT"

# Ініціалізація змінних
PREV_LOCAL_BLOCK=0
PREV_TIME=0
FIRST_RUN=true
SYNCED=false

echo -e "${BLUE}📡 Старт моніторингу порту $PORT...${NC}"

while true; do
  CURRENT_TIME=$(date '+%H:%M:%S')

  # Отримання блоків
  REMOTE_BLOCK=$(curl -s "$REMOTE_URL" | jq -r '.result.blockNumber')

  RESPONSE=$(curl -s -X POST "$ENDPOINT" \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"zgs_getStatus","params":[],"id":1}')

  LOCAL_BLOCK=$(echo "$RESPONSE" | jq -r '.result.logSyncHeight')
  CONNECTED_PEERS=$(echo "$RESPONSE" | jq -r '.result.connectedPeers')

  # Перевірка помилок
  if [[ -z "$REMOTE_BLOCK" || -z "$LOCAL_BLOCK" || "$REMOTE_BLOCK" == "null" || "$LOCAL_BLOCK" == "null" ]]; then
    echo -e "${RED}[$CURRENT_TIME][$PORT] ❌ Помилка отримання даних.${NC}"
    sleep "$INTERVAL"
    continue
  fi

  REMAINING=$((REMOTE_BLOCK - LOCAL_BLOCK))
  OUTPUT="${YELLOW}[$CURRENT_TIME] 🔄 Блоки: $LOCAL_BLOCK / $REMOTE_BLOCK | Піри: $CONNECTED_PEERS${NC}"

  # Якщо ще не синхронізовано
  if (( REMAINING > 0 )); then
    OUTPUT="${YELLOW}[$CURRENT_TIME] ⏳ Залишилось: $REMAINING блоків (лок: $LOCAL_BLOCK / віддал: $REMOTE_BLOCK) | Піри: $CONNECTED_PEERS"
    SYNCED=false
  else
    if [ "$SYNCED" = false ]; then
      echo -e "${GREEN}[$CURRENT_TIME] ✅ Синхронізація завершена! (локальний: $LOCAL_BLOCK / віддалений: $REMOTE_BLOCK)${NC}"
      SYNCED=true
    fi
    OUTPUT="${GREEN}[$CURRENT_TIME] 📦 Синхронізовано | Блок: $LOCAL_BLOCK | Піри: $CONNECTED_PEERS${NC}"
  fi

  # Розрахунок швидкості/ETA (тільки якщо ще не синхронізовано)
  if [ "$FIRST_RUN" = false ] && [ "$SYNCED" = false ]; then
    BLOCK_DIFF=$((LOCAL_BLOCK - PREV_LOCAL_BLOCK))
    TIME_DIFF=$(( $(date +%s) - PREV_TIME ))

    if (( TIME_DIFF > 0 && BLOCK_DIFF > 0 )); then
      SPEED=$(echo "scale=2; $BLOCK_DIFF / $TIME_DIFF" | bc)
      ETA_SECONDS=$(echo "scale=0; $REMAINING / $SPEED" | bc)
      ETA_MINUTES=$((ETA_SECONDS / 60))
      ETA_HOURS=$((ETA_MINUTES / 60))
      ETA_MINUTES=$((ETA_MINUTES % 60))
      ETA_SECONDS=$((ETA_SECONDS % 60))
      OUTPUT+=" ${CYAN}⏱ ETA: ${ETA_HOURS}г ${ETA_MINUTES}хв ${ETA_SECONDS}с${NC}"
    else
      OUTPUT+=" ${CYAN}🚀 Швидкість: недостатньо даних.${NC}"
    fi
  else
    FIRST_RUN=false
  fi

  echo -e "$OUTPUT"

  # Оновлення для наступного циклу
  PREV_LOCAL_BLOCK=$LOCAL_BLOCK
  PREV_TIME=$(date +%s)

  sleep "$INTERVAL"
done

