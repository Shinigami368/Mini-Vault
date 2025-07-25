#!/bin/bash

LOG_FILE="system_report.log"
JSON_LOG="system_report.jsonl"
> "$LOG_FILE"
> "$JSON_LOG"

EXIT_CODE=0

log() {
    local level=$1
    local message=$2
    local timestamp=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$level] $message" >> "$LOG_FILE"
    echo "{\"timestamp\":\"$timestamp\",\"level\":\"$level\",\"component\":\"diagnostic\",\"message\":\"$message\"}" >> "$JSON_LOG"
}

log "INFO" "Starting system check..."

# OS
if [ -f /etc/os-release ]; then
    log "INFO" "OS detected: $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '\"')"
else
    log "ERROR" "OS info not found"
    EXIT_CODE=1
fi

# GPU
if command -v nvidia-smi &> /dev/null; then
    GPU=$(nvidia-smi --query-gpu=name,driver_version --format=csv,noheader | head -n 1)
    log "INFO" "NVIDIA GPU found: $GPU"
else
    log "WARNING" "No NVIDIA GPU found or 'nvidia-smi' unavailable"
fi

# Docker
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    log "INFO" "Docker installed: $DOCKER_VERSION"
else
    log "ERROR" "Docker not installed"
    EXIT_CODE=2
fi

# CUDA
CUDA_PATHS=$(ls -d /usr/local/cuda* 2>/dev/null)
if [ -n "$CUDA_PATHS" ]; then
    log "INFO" "CUDA found at: $CUDA_PATHS"
else
    log "WARNING" "CUDA not found"
fi

log "INFO" "System check complete with exit code $EXIT_CODE"
exit $EXIT_CODE
