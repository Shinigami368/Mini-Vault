#!/bin/bash

LOG_FILE="gpu_health.log"
JSON_LOG="gpu_health.jsonl"
> "$LOG_FILE"
> "$JSON_LOG"

log() {
    local temp=$1
    local mem_total=$2
    local mem_used=$3
    local util=$4
    local timestamp=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] TEMP: $temp°C | MEM: $mem_used/$mem_total MB | UTIL: $util%" >> "$LOG_FILE"
    echo "{\"timestamp\":\"$timestamp\",\"gpu_temp_c\":$temp,\"mem_total_mb\":$mem_total,\"mem_used_mb\":$mem_used,\"util_percent\":$util}" >> "$JSON_LOG"
}

# Use absolute path fallback if command -v fails
if ! which nvidia-smi &>/dev/null && [ ! -x /usr/lib/wsl/lib/nvidia-smi ]; then
    echo "nvidia-smi not found or not executable. Exiting."
    exit 1
fi

# Use full path explicitly
NVIDIA_SMI=$(which nvidia-smi || echo "/usr/lib/wsl/lib/nvidia-smi")

DATA=$($NVIDIA_SMI --query-gpu=temperature.gpu,memory.total,memory.used,utilization.gpu \
                   --format=csv,noheader,nounits | head -n 1)

IFS=',' read -r TEMP MEM_TOTAL MEM_USED UTIL <<< "$DATA"

log "$TEMP" "$MEM_TOTAL" "$MEM_USED" "$UTIL"
