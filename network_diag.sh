#!/bin/bash

# List of hosts to check connectivity
hosts=("wikipedia.org" "google.com" "github.com")

# Function to check connectivity to hosts
check_connectivity() {
    echo "Checking connectivity to hosts..."
    for host in "${hosts[@]}"; do
        if ping -c 1 "$host" &> /dev/null; then
            echo "Connected to $host"
        else
            echo "Failed to connect to $host"
        fi
    done
}

# Function to test DNS resolution
test_dns_resolution() {
    echo "Testing DNS resolution..."
    for host in "${hosts[@]}"; do
        if nslookup "$host" &> /dev/null; then
            echo "DNS resolution for $host is successful"
        else
            echo "DNS resolution for $host failed"
        fi
    done
}

# Function to analyze network latency
analyze_network_latency() {
    echo "Analyzing network latency..."
    for host in "${hosts[@]}"; do
        if ping -c 5 "$host" &> /dev/null; then
            avg_latency=$(ping -c 5 "$host" | awk '/^rtt/ {print $4}' | cut -d '/' -f 2)
            if [[ -n $avg_latency ]]; then
                echo "Average latency to $host: $avg_latency ms"
            else
                echo "Unable to calculate latency to $host"
            fi
        else
            echo "Failed to analyze latency to $host"
        fi
    done
}

# Main function
main() {
    check_connectivity
    test_dns_resolution
    analyze_network_latency
}

# Execute main function
main
