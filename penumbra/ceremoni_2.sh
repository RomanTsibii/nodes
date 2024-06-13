#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/penumbra/ceremoni_2.sh) 0
# screen -S run_penumbra_ceremoni_2 -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/penumbra/ceremoni_2.sh) 0"
# глянути логи  - "tail -f -n 10 /var/log/penumbra_ceremoni_2.log"
# глянути останній рялок логу - "tail -n 1 /var/log/penumbra_ceremoni_2.log"

# Отримати баланс
function full_balance {
  balance=$(pcli view balance | grep "penumbra " | awk '{print $3}' | sed 's/penumbra//')
  balance_number=$(echo $balance | awk '{print $1 + 0}') # Конвертуємо у числове значення
  rounded_balance=$(printf "%.0f" "$balance_number") # Заокруглюємо до цілого значення
  echo $rounded_balance
}

function balance_for_ceremoni {
  # Перевірка на мінімальний баланс
  if [ "$rounded_balance" -gt 99 ]; then
    # Згенерувати випадкове число від 5 до 10
    random_number=$(shuf -i 5-10 -n 1)
  
    # Відняти випадкове число від балансу 
    new_balance=$((rounded_balance - random_number))
    ceremoni_balance=$new_balance
  else
    echo "balance less 100"
    exit # не робити нічого якщо баланс нижче 100
  fi
  # Вивести результати
  echo "Ceremoni balance: $ceremoni_balance"
  # добавляємо до числового значення  {550penumbra}
  ceremoni_balance_with_suffix="${ceremoni_balance}penumbra"
}

function remove_old_session {
  SESSION_NAME="penumbra_ceremoni_2"
  LOG_FILE="/var/log/penumbra_ceremoni_2.log"
  # Перевірка, чи існує сесія
  if screen -list | grep -q "$SESSION_NAME"; then
    echo "Сесія $SESSION_NAME вже існує. Закриття..."
    screen -ls | grep "$SESSION_NAME" | awk '{print $1}' | xargs -I {} screen -S {} -X quit
  fi
}

function create_new_session {
  # Запуск нової сесії
  screen -dmS "$SESSION_NAME"
  sleep 1
  # добавити файл логування 
  screen -S "$SESSION_NAME" -X logfile "$LOG_FILE"
  screen -S "$SESSION_NAME" -X log on
  # Виконання команди в новій сесії
  screen -S "$SESSION_NAME" -X stuff "pcli ceremony contribute --phase 2 --bid $ceremoni_balance_with_suffix"
  sleep 1
  screen -S "$SESSION_NAME" -X stuff $'\n' # натискання Enter
}

full_balance
balance_for_ceremoni
remove_old_session
create_new_session
