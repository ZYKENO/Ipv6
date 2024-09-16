#!/bin/bash

# Function to generate a random part of the IPv6 address
generate_random_part() {
    echo "$(hexdump -n 2 -e '1/2 "%04x"' /dev/urandom)"
}

# Function to validate an IPv6 address
validate_ipv6() {
    if [[ $1 =~ ^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to generate realistic usage statistics
generate_realistic_stats() {
    local days=$(( (RANDOM % 730) + 1 ))
    local data_gb=$(( (RANDOM % 491) + 10 ))
    local avg_latency=$(( (RANDOM % 50) + 1 ))
    echo "$days days, $data_gb GB, avg latency $avg_latency ms"
}

# Function to save output to a file
save_output() {
    echo -e "$1" >> output.txt
}

# Function to ping an IPv6 address
ping_ipv6() {
    local ip="$1"
    response=$(ping6 -c 1 "$ip" 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "$ip is reachable."
    else
        echo "$ip is not reachable."
    fi
}

# Function to generate strong DNS addresses with realistically enhanced stats
generate_strong_dns() {
    for i in {1..10}; do
        part6=$(generate_random_part)
        part7=$(generate_random_part)
        part8=$(generate_random_part)
        ipv6="329c:1a40:0:4:db5b:$part6:$part7:$part8"
        
        # Validate the IPv6 address
        if validate_ipv6 "$ipv6"; then
            # Get realistic usage statistics
            usage_stats=$(generate_realistic_stats)
            
            # Compose the output
            output="IPv6 Address: $ipv6\nRealistic Usage Period and Data Volume: $usage_stats\n"
            
            # Display the results
            echo -e "$output"
            
            # Save the results to a file
            save_output "$output"

            # Ping the IPv6 address
            ping_ipv6 "$ipv6"
        else
            echo "Invalid IPv6 address generated: $ipv6"
        fi
    done
}

# Main function to be called at the script start
main() {
    if [ -f output.txt ]; then
        mv output.txt output_backup.txt
        echo "Previous output backed up to output_backup.txt"
    fi
    
    generate_strong_dns
    
    echo "DNS generation completed. Results saved to output.txt"
}

# Call the main function
main
