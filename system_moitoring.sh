#!/bin/bash

# System Monitoring Script

# Function to get CPU usage
get_cpu_usage() {
  cpu_usage=$(top -b -n 1 | grep "%Cpu(s)" | awk '{print $2}')
  printf "| %-20s | %-10s           |\n" "CPU Usage" "${cpu_usage}%"
}

# Function to get memory usage
get_memory_usage() {
  memory_info=$(free -m | grep Mem)
  total_memory=$(echo $memory_info | awk '{print $2}')
  used_memory=$(echo $memory_info | awk '{print $3}')
  printf "| %-20s | %-10s     |\n" "Memory Usage" "${used_memory}MB / ${total_memory}MB"
}

# Function to get disk space
get_disk_space() {
  disk_info=$(df -h / | tail -n 1)
  used_space=$(echo $disk_info | awk '{print $3}')
  free_space=$(echo $disk_info | awk '{print $4}')
  printf "| %-20s | %-10s |\n" "Disk Space" "${free_space} free / ${used_space} used"
}

# Display system information in a table
while true; do
  clear  # Clear the terminal screen for a cleaner display
  echo "System Monitoring Script"
  echo "+----------------------+----------------------+"
  echo "|      Information     |       Value          |"
  echo "+----------------------+----------------------+"

  get_cpu_usage
  get_memory_usage
  get_disk_space

  echo "+----------------------+---------------------+"
  sleep 2  # Adjust the sleep duration as needed (in seconds)
done