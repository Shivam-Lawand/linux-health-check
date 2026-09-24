#!/bin/bash

# ==========================================
# Linux Server Health Check Script
# Author: Shivam Lawand
# Purpose: Quickly check disk usage, memory, top processes,
#          and key service status on a Linux system.
# ==========================================

# --- Configuration ---
DISK_THRESHOLD=80          # Percent full - flag disk if it crosses this
LOG_FILE="$HOME/health_check.log"
SERVICES_TO_CHECK=("sshd" "crond" "firewalld")   # Edit to match services on YOUR system

# --- Helper: print a section header ---
print_header() {
    echo ""
    echo "==================================================="
    echo " $1"
    echo "==================================================="
}

# --- Start report ---
REPORT_TIME=$(date '+%Y-%m-%d %H:%M:%S')
echo "Linux Health Check Report - $REPORT_TIME" | tee -a "$LOG_FILE"

# --- 1. Disk Usage Check ---
print_header "DISK USAGE" | tee -a "$LOG_FILE"
df -h --output=target,pcent | grep -vE '^(Mounted|/boot|/dev)' | while read -r line; do
    echo "$line" | tee -a "$LOG_FILE"
    usage=$(echo "$line" | awk '{print $2}' | tr -d '%')
    mount=$(echo "$line" | awk '{print $1}')
    if [ "$usage" -ge "$DISK_THRESHOLD" ] 2>/dev/null; then
        echo "  WARNING: $mount is at ${usage}% - above threshold of ${DISK_THRESHOLD}%" | tee -a "$LOG_FILE"
    fi
done

# --- 2. Memory Usage Check ---
print_header "MEMORY USAGE" | tee -a "$LOG_FILE"
free -h | tee -a "$LOG_FILE"

# --- 3. Top 5 Processes by CPU ---
print_header "TOP 5 PROCESSES BY CPU" | tee -a "$LOG_FILE"
ps aux --sort=-%cpu | head -6 | tee -a "$LOG_FILE"

# --- 4. Top 5 Processes by Memory ---
print_header "TOP 5 PROCESSES BY MEMORY" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -6 | tee -a "$LOG_FILE"

# --- 5. Key Services Status ---
print_header "KEY SERVICES STATUS" | tee -a "$LOG_FILE"
for service in "${SERVICES_TO_CHECK[@]}"; do
    if systemctl is-active --quiet "$service"; then
        echo "  $service: RUNNING" | tee -a "$LOG_FILE"
    else
        echo "  $service: NOT RUNNING (or not installed)" | tee -a "$LOG_FILE"
    fi
done

# --- End of report ---
print_header "HEALTH CHECK COMPLETE" | tee -a "$LOG_FILE"
echo "Report saved to: $LOG_FILE"
