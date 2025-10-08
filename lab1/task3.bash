#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Использование: $0 <лог-файл> <ключевое-слово>"
    exit 1
fi

LOG_FILE="$1"
KEYWORD="$2"

if [ ! -f "$LOG_FILE" ]; then
    echo "Ошибка: Файл '$LOG_FILE' не существует"
    exit 1
fi

BASE_NAME=$(basename "$LOG_FILE" | sed 's/\.[^.]*$//')  # Убираем расширение
COUNT_FILE="${BASE_NAME}_${KEYWORD}_count.txt"
ENTRIES_FILE="${BASE_NAME}_${KEYWORD}_entries.txt"

# Подсчитываем количество вхождений
COUNT=$(grep -c "$KEYWORD" "$LOG_FILE")

# Сохраняем результаты
echo "$COUNT" > "$COUNT_FILE"
grep "$KEYWORD" "$LOG_FILE" > "$ENTRIES_FILE"

echo "=== Анализ завершен ==="
echo "Лог-файл: $LOG_FILE"
echo "Ключевое слово: '$KEYWORD'"
echo "Найдено вхождений: $COUNT"
echo "Файл с количеством: $COUNT_FILE"
echo "Файл с найденными строками: $ENTRIES_FILE"