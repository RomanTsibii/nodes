#!/usr/bin/env bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/aztec/proof.sh)
set -euo pipefail

# Кольори
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
NC=$'\033[0m'

# 1. Отримуємо адресу з .evm-файлу (без префікса WALLET=)
ADDRESS=$(grep '^WALLET=' /root/aztec-sequencer/.evm | cut -d'=' -f2)

# 2. Отримуємо останній доведений блок
TIP_RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"node_getL2Tips","params":[],"id":67}' \
  http://localhost:8080)

BLOCK_NUMBER=$(printf '%s' "$TIP_RESPONSE" | jq -r '.result.proven.number')

if ! [[ "$BLOCK_NUMBER" =~ ^[0-9]+$ ]]; then
  echo -e "${RED}❌ Помилка: очікувався номер блоку, а не: $BLOCK_NUMBER${NC}" >&2
  exit 1
fi

# 3. Отримуємо proof
ARCHIVE_PROOF=$(curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"jsonrpc\":\"2.0\",\"method\":\"node_getArchiveSiblingPath\",\"params\":[$BLOCK_NUMBER,$BLOCK_NUMBER],\"id\":67}" \
  http://localhost:8080 | jq -r '.result')

if [[ -z "$ARCHIVE_PROOF" || "$ARCHIVE_PROOF" == "null" ]]; then
  echo -e "${RED}❌ Помилка: proof не отримано для блоку $BLOCK_NUMBER${NC}" >&2
  exit 1
fi

# 4. Вивід у форматі Aztec
echo "/operator start address: $ADDRESS block-number: $BLOCK_NUMBER proof: $ARCHIVE_PROOF"
