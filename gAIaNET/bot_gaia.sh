#!/bin/bash

# Файл із фразами
file=($(jq -r '.pathToFile' /root/gaianet/bot_config.json))

# Перевіряємо, чи встановлена змінна середовища API_URL
# if [[ -z "${API_URL}" ]]; then
#     echo "Error: API_URL environment variable is not set."
#     exit 1
# fi

# URL для API (тільки зі змінної середовища)
url=($(jq -r '.url' /root/gaianet/bot_config.json))
echo "API URL: $url"

# Файли для збереження виводу
log_file="log_output.txt"
stats_file="token_stats.txt"
responses_file="responses.txt"

# Змінні для налаштування динамічного контролю запитів
max_time=120  # Максимальний час очікування для одного запиту (60 секунд)
request_words=350  # Початкове значення для кількості символів у запиті
execution_times=()  # Масив для зберігання часу виконання останніх 50 запитів
tokens_per_second_values=()  # Масив для зберігання кількості токенів на секунду за останні 50 запитів

# Змінні для збереження загальної кількості токенів, кількості запитів та загального часу виконання запитів
total_sum=0
request_count=0
total_execution_time=0
average_tokens_per_second=0

# Функція для обчислення середнього часу останніх 50 запитів
calculate_average_execution_time_50() {
    local sum=0
    local count=${#execution_times[@]}

    if [[ $count -gt 0 ]]; then
        for time in "${execution_times[@]}"; do
            sum=$((sum + time))
        done
        average_execution_time_50=$((sum / count))
    else
        average_execution_time_50=0
    fi
}

# Функція для обчислення середньої кількості токенів на секунду за останні 50 запитів
calculate_average_tokens_per_second() {
    local sum=0
    local count=${#tokens_per_second_values[@]}

    if [[ $count -gt 0 ]]; then
        for tps in "${tokens_per_second_values[@]}"; do
            sum=$(echo "$sum + $tps" | bc)
        done
        average_tokens_per_second=$(echo "scale=2; $sum / $count" | bc)
    else
        average_tokens_per_second=0
    fi
}

# Функція для збереження статистики у файл
save_stats() {
    echo "Request: $line" >> "$stats_file"
    echo "Content: $content" >> "$stats_file"
    echo "Tokens: $tokens, Execution time: ${execution_time}s, Tokens per second: $tokens_per_second" >> "$stats_file"
    echo "------------------------" >> "$stats_file"
}

# Функція для збереження відповідей у файл (оновлено для запису всіх змінних)
save_response() {
    echo "Request: $line" >> "$responses_file"
    echo "Response: $content" >> "$responses_file"
    echo "Tokens: $tokens" >> "$responses_file"
    echo "Execution time: ${execution_time}s" >> "$responses_file"
    echo "Tokens per second: $tokens_per_second" >> "$responses_file"
    echo "Request count: $request_count" >> "$responses_file"
    echo "Average execution time (last 50 requests): ${average_execution_time_50}s" >> "$responses_file"
    echo "Average tokens per second (last 50 requests): ${average_tokens_per_second}" >> "$responses_file"
    echo "Request words: $request_words" >> "$responses_file"
    echo "------------------------" >> "$responses_file"
}

# Функція для динамічного регулювання кількості слів у запиті
adjust_request_words() {
    calculate_average_execution_time_50  # Обчислюємо середній час для останніх 50 запитів
    calculate_average_tokens_per_second  # Обчислюємо середню кількість токенів на секунду за останні 50 запитів

    if [[ $average_execution_time_50 -gt 50 ]]; then
        request_words=$((request_words - 30))  # Зменшуємо на 30, якщо середній час > 50 секунд
    elif [[ $average_execution_time_50 -lt 20 ]]; then
        request_words=$((request_words + 30))  # Збільшуємо на 30, якщо середній час < 40 секунд
    fi

    # Перевіряємо, щоб request_words не стало негативним або занадто малим
    if [[ $request_words -lt 50 ]]; then
        request_words=50
    fi
}

# Функція для надсилання запиту до API
send_request() {
    local line=$1
    start_time=$(date +%s)
    max_retry=3
    retry_count=0

    # Екранування рядка для безпечного включення в JSON
    escaped_line=$(echo "$line" | jq -R .)

    while [[ $retry_count -lt $max_retry ]]; do
        echo "Do request..."
        # Виконання запиту з динамічною зміною кількості символів
        response=$(curl -s --max-time $max_time -X POST "$url" \
            -H 'accept: application/json' \
            -H 'Content-Type: application/json' \
            -d "{\"messages\":[{\"role\":\"system\", \"content\": \"You are a helpful assistant. Please provide a response that is close to ${request_words} characters.\"}, {\"role\":\"user\", \"content\": $escaped_line}]}")

        # Виведення відповіді для діагностики
        # echo "API response: $response" | tee -a "$log_file"

        # Перевірка на валідність JSON-формату
        if echo "$response" | jq empty 2>/dev/null; then
            # Обробка валідного JSON
            tokens=$(echo "$response" | jq -r '.usage.total_tokens // 0')
            content=$(echo "$response" | jq -r '.choices[0].message.content // "No content"' | sed 's/^/      /')
            break
        elif [[ "$response" == *"504 Gateway Time-out"* ]]; then
            echo "504 Gateway Time-out error. Retrying..." | tee -a "$log_file"
            sleep 5
            retry_count=$((retry_count + 1))
        else
            echo "Invalid JSON response: $response. Retrying in 5 seconds..." | tee -a "$log_file"
            sleep 5
            retry_count=$((retry_count + 1))
        fi
    done

    # Якщо після всіх спроб виникла помилка або час виконання > 59 секунд, зменшуємо request_words на 100
    if [[ $retry_count -eq $max_retry || $execution_time -gt 59 ]]; then
        echo "Request words reduced by 100 due to timeout or execution time exceeding 59 seconds." | tee -a "$log_file"
        request_words=$((request_words - 100))
    fi

    # Кінцевий час і тривалість
    end_time=$(date +%s)
    execution_time=$((end_time - start_time))

    # Додаємо кількість запитів та час виконання
    request_count=$((request_count + 1))
    total_execution_time=$((total_execution_time + execution_time))

    # Зберігаємо час виконання останніх 50 запитів
    execution_times+=("$execution_time")
    if [[ ${#execution_times[@]} -gt 15 ]]; then
        execution_times=("${execution_times[@]:1}")  # Зберігаємо тільки останні 50 значень
    fi

    # Обчислюємо кількість токенів за секунду
    if [[ $execution_time -gt 0 && $tokens -gt 0 ]]; then
        tokens_per_second=$(echo "scale=2; $tokens / $execution_time" | bc)
        # Зберігаємо токени за секунду, тільки якщо значення валідне
        tokens_per_second_values+=("$tokens_per_second")
        if [[ ${#tokens_per_second_values[@]} -gt 50 ]]; then
            tokens_per_second_values=("${tokens_per_second_values[@]:1}")  # Зберігаємо тільки останні 50 значень
        fi
    else
        echo "Error: Invalid execution time or tokens, skipping tokens per second calculation" | tee -a "$log_file"
    fi

    # Виводимо результат із відступами для кожного рядка, записуємо в файл окрім суми балансу
    echo '----------------------------------------------------------------------------' | tee -a "$log_file"
    echo "      Request: $line" | tee -a "$log_file"

    echo "      Content: " | tee -a "$log_file"
    echo "$content" | sed 's/^/      /' | tee -a "$log_file"

    echo "      Total tokens: $tokens" | tee -a "$log_file"
    echo "      Execution time: ${execution_time}s" | tee -a "$log_file"
    echo "      Tokens per second: $tokens_per_second" | tee -a "$log_file"
    echo "      Request count: $request_count" | tee -a "$log_file"
    echo "      Average execution time (last 50 requests): ${average_execution_time_50}s" | tee -a "$log_file"
    echo "      Average tokens per second (last 50 requests): ${average_tokens_per_second}" | tee -a "$log_file"
    echo "      Request words: $request_words" | tee -a "$log_file"

    # Додаємо кількість токенів до загальної суми
    total_sum=$((total_sum + tokens))

    # Виводимо загальну кількість токенів зеленим кольором, але не записуємо в лог-файл
    echo -e "\033[32m      Total tokens sum: $total_sum\033[0m"

    # Зберігаємо статистику та відповідь
    save_stats
    save_response

    # Регулюємо кількість слів у наступних запитах
    adjust_request_words
}

# Нескінченний цикл для читання випадкових рядків із файлу та надсилання запитів
while true; do
    if [[ -f $file ]]; then
        # Отримуємо випадковий рядок із файлу
        line=$(shuf -n 1 "$file")
        send_request "$line"

        # Затримка перед наступним запитом
        # sleep 1
    else
        echo "File '$file' not found. Retrying in 5 seconds..." | tee -a "$log_file"
        request_words=$((request_words - 100))  # Зменшуємо на 100 у випадку помилки
        sleep 5
    fi
done
