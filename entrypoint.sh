#!/bin/bash

LOG_FILE="inference.log"
JSON_LOG="inference.jsonl"
> "$LOG_FILE"
> "$JSON_LOG"

log() {
    local level=$1
    local message=$2
    local timestamp=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$level] $message" >> "$LOG_FILE"
    echo "{\"timestamp\":\"$timestamp\",\"level\":\"$level\",\"component\":\"inference\",\"message\":\"$message\"}" >> "$JSON_LOG"
}

# Check input
if [ ! -f input.json ]; then
    log "ERROR" "Missing input.json"
    exit 1
fi

log "INFO" "Inference stub started"
sleep 1  # simulate processing

# Simulate output
jq '. + {response: "This is a fake model response"}' input.json > output.json

log "INFO" "Inference complete"
echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"level\":\"INFO\",\"component\":\"inference\",\"message\":\"Model processing completed\",\"model\":\"test-model\",\"duration_ms\":1500}" >> "$JSON_LOG"
