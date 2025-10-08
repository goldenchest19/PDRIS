#!/bin/bash 

if [ "$#" -ne 3 ]; then
    echo "Использование: $0 <репозиторий> <ветка_1> <ветка_2>"
    exit 1
fi

REPO_URL="$1"
BRANCH1="$2"
BRANCH2="$3"
REPO_NAME=$(basename -s .git "$REPO_URL")
CLONE_DIR="./temp_$REPO_NAME"
REPORT_FILE="diff_report_${BRANCH1}_vs_${BRANCH2}.txt"

# Очистка от предыдущих остатков
rm -rf "$CLONE_DIR"

git clone --quiet --no-checkout "$REPO_URL" "$CLONE_DIR"
cd "$CLONE_DIR" || exit 1

# Получение diff
DIFF_SUMMARY=$(git diff --name-status origin/"$BRANCH1" origin/"$BRANCH2")

# Подсчет статистики
TOTAL_FILES=$(echo "$DIFF_SUMMARY" | wc -l)
ADDED=$(echo "$DIFF_SUMMARY" | grep -c '^A' || true)
DELETED=$(echo "$DIFF_SUMMARY" | grep -c '^D' || true)
MODIFIED=$(echo "$DIFF_SUMMARY" | grep -c '^M' || true)

# Генерация отчета
{
    echo "Отчет о различиях между ветками"
    echo ""
    echo "================================"
    echo "Репозиторий:    $REPO_URL"
    echo "Ветка 1:        $BRANCH1"
    echo "Ветка 2:        $BRANCH2"
    echo "Дата генерации: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "================================"
    echo ""
    echo "СПИСОК ИЗМЕНЕННЫХ ФАЙЛОВ:"
    echo "$DIFF_SUMMARY"
    echo ""
    echo "СТАТИСТИКА:"
    echo "Всего измененных файлов: $TOTAL_FILES"
    echo "Добавлено (A):    $ADDED"
    echo "Удалено (D):      $DELETED"
    echo "Изменено (M):     $MODIFIED"
} > "../$REPORT_FILE"

# Возврат и очистка
cd ..
rm -rf "$CLONE_DIR"

# Вывод сообщения
echo "Отчет сохранен в $REPORT_FILE"