#!/bin/bash
# Використання: bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/validator_statistic.sh) 

# Кольори
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
CYAN=$'\033[0;36m'
NC=$'\033[0m' # Скидання кольору

# Інтервал між перевірками (в секундах)
INTERVAL=30

# URL віддаленого вузла
REMOTE_URL="https://chainscan-galileo.0g.ai/v1/homeDashboard"

# Ініціалізація змінних
PREV_LOCAL_BLOCK=0
PREV_TIME=0
FIRST_RUN=true

while true; do
  CURRENT_TIME=$(date '+%H:%M:%S')

  # Отримання номера блоку віддаленого вузла
  REMOTE_BLOCK=$(curl -s "$REMOTE_URL" | jq -r '.result.blockNumber')

  # Отримання номера блоку локального вузла
  LOCAL_BLOCK=$(curl -s http://localhost:12657/status | jq -r '.result.sync_info.latest_block_height')

  # Перевірка наявності помилок у відповіді
  if [[ -z "$REMOTE_BLOCK" || -z "$LOCAL_BLOCK" || "$REMOTE_BLOCK" == "null" || "$LOCAL_BLOCK" == "null" ]]; then
    echo -e "${RED}[$CURRENT_TIME] ❌ Помилка: не вдалося отримати дані про блоки.${NC}"
    sleep "$INTERVAL"
    continue
  fi

  # Обчислення кількості блоків, що залишилися
  REMAINING=$((REMOTE_BLOCK - LOCAL_BLOCK))

  # Вивід результату
  if (( REMAINING > 0 )); then
    OUTPUT="${YELLOW}[$CURRENT_TIME] ⏳ Залишилося: $REMAINING блоків (локальний: $LOCAL_BLOCK / віддалений: $REMOTE_BLOCK)"
  else
    OUTPUT="${GREEN}[$CURRENT_TIME] ✅ Синхронізація завершена! (локальний: $LOCAL_BLOCK / віддалений: $REMOTE_BLOCK)${NC}"
  fi

  # Обчислення швидкості синхронізації та оцінка залишкового часу
  if [ "$FIRST_RUN" = false ]; then
    BLOCK_DIFF=$((LOCAL_BLOCK - PREV_LOCAL_BLOCK))
    TIME_DIFF=$(( $(date +%s) - PREV_TIME ))

    if (( TIME_DIFF > 0 && BLOCK_DIFF > 0 )); then
      SPEED=$(echo "scale=2; $BLOCK_DIFF / $TIME_DIFF" | bc)
      ETA_SECONDS=$(echo "scale=0; $REMAINING / $SPEED" | bc)
      ETA_MINUTES=$((ETA_SECONDS / 60))
      ETA_HOURS=$((ETA_MINUTES / 60))
      ETA_MINUTES=$((ETA_MINUTES % 60))
      ETA_SECONDS=$((ETA_SECONDS % 60))
      OUTPUT+=" ${CYAN}⏱️ Залишковий час: ${ETA_HOURS}г ${ETA_MINUTES}хв ${ETA_SECONDS}с${NC}"
    else
      OUTPUT+=" ${CYAN}🚀 Швидкість: недостатньо даних для оцінки.${NC}"
    fi
  else
    FIRST_RUN=false
  fi

  echo -e "$OUTPUT"

  # Оновлення попередніх значень
  PREV_LOCAL_BLOCK=$LOCAL_BLOCK
  PREV_TIME=$(date +%s)

  sleep "$INTERVAL"
done
