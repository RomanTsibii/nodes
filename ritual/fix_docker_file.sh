#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/ritual/fix_docker_file.sh)

FILE="$HOME/infernet-container-starter/deploy/docker-compose.yaml"

awk '
  # Якщо знайшли "container_name: infernet-anvil", встановлюємо прапорець
  /container_name: infernet-anvil/ { found=1; print; next }

  # Якщо знайдений другий екземпляр "restart: on-failure" після infernet-anvil, пропускаємо його
  found && /restart: on-failure/ && ++count == 2 { found=0; next }

  # Друкуємо всі інші рядки
  { print }
' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
