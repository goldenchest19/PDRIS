#!/bin/bash

set -e

echo "Проверяем доступность Docker..."
if ! docker info >/dev/null 2>&1; then
    echo "Docker daemon не доступен! Проверьте, что Docker запущен."
    exit 1
fi

APP_DIR="/home/admin/app"
cd "$APP_DIR"

echo "Останавливаем старые контейнеры (если есть)..."
docker-compose down || true

echo "Запускаем контейнеры..."
docker-compose up -d

echo "Приложение запущено!"
docker ps
