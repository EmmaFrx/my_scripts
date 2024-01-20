#!/bin/bash

get_cpu_usage() {
  cpu_usage=$(top -b -n 1 | grep "%Cpu(s)" | awk '{print $2}')
  echo "CPU Usage: ${cpu_usage}%"
}

get_memory_usage() {
  memory_info=$(free -m | grep Mem)
  total_memory=$(echo $memory_info | awk '{print $2}')
  used_memory=$(echo $memory_info | awk '{print $3}')
  echo "Memory Usage: ${used_memory}MB / ${total_memory}MB"
}

get_disk_space() {
  disk_info=$(df -h / | tail -n 1)
  used_space=$(echo $disk_info | awk '{print $3}')
  free_space=$(echo $disk_info | awk '{print $4}')
  echo "Disk Space: ${free_space} free / ${used_space} used"
}

while true; do
  clear
  echo "System Monitoring Script"

  get_cpu_usage
  get_memory_usage
  get_disk_space

  sleep 1  # Adjust the sleep duration as needed (in seconds)
done