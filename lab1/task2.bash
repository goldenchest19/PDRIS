#!/bin/bash

LOG_DIR="$HOME"
DATE=$(date +%F)
CSV_FILE="$LOG_DIR/system_report_${DATE}.csv"

collect_metrics() {
    while true; do
        timestamp=$(date "+%Y-%m-%d %H:%M:%S")

        mem_total=$(sysctl -n hw.memsize)
        
        memory_info=$(vm_stat)
        pages_free=$(echo "$memory_info" | grep "Pages free" | awk '{print $3}' | tr -d '.')
        pages_active=$(echo "$memory_info" | grep "Pages active" | awk '{print $3}' | tr -d '.')
        pages_inactive=$(echo "$memory_info" | grep "Pages inactive" | awk '{print $3}' | tr -d '.')
        pages_wired=$(echo "$memory_info" | grep "Pages wired down" | awk '{print $4}' | tr -d '.')
        
        page_size=$(pagesize)  
        
        used_mem=$(( (pages_active + pages_wired) * page_size ))
        free_mem=$(( (pages_free + pages_inactive) * page_size ))
                
        mem_used_percent=$(( used_mem * 100 / mem_total ))

        # CPU usage
        cpu_used_percent=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.1f", s}')

        # Disk usage
        disk_used_percent=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

        # Load average
        load_avg_1m=$(sysctl -n vm.loadavg | awk '{print $2}')

        # Запись в CSV
        echo "${timestamp};$((mem_total/1024/1024));$((free_mem/1024/1024));$mem_used_percent;${cpu_used_percent};${disk_used_percent};${load_avg_1m}" >> "$CSV_FILE"

        sleep 60
    done
}

get_monitor_pid() {
    # Находим PID скрипта, запущенного в режиме 'run'
    pgrep -f "$0 run"
}

start_monitor() {
    PID=$(get_monitor_pid)
    if [ -n "$PID" ]; then
        echo "Уже запущен (PID: $PID)"
        exit 1
    fi

    echo "Запуск мониторинга..."
    nohup "$0" run >> /dev/null 2>&1 &
    echo "Мониторинг запущен. PID: $!"
}

stop_monitor() {
    PID=$(get_monitor_pid)
    if [ -n "$PID" ]; then
        kill "$PID"
        echo "Мониторинг остановлен (PID: $PID)"
    else
        echo "Мониторинг не запущен"
    fi
}

status_monitor() {
    PID=$(get_monitor_pid)
    if [ -n "$PID" ]; then
        echo "Мониторинг запущен (PID: $PID)"
    else
        echo "Мониторинг не запущен"
    fi
}

case "$1" in
    START)
        start_monitor
        ;;
    STOP)
        stop_monitor
        ;;
    STATUS)
        status_monitor
        ;;
    run)  
        collect_metrics
        ;;
    *)
        echo "Использование: $0 {START|STOP|STATUS}"
        ;;
esac