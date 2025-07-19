#!/bin/bash
# Usage: bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/latency_base_rpc.sh) rpc1,rpc2,rpc3
# Usage: bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/latency_base_rpc.sh) rpc1

# Default RPC if none provided
DEFAULT_RPC="https://mainnet.base.org"
DURATION=20  # duration in seconds

# Parse input RPCs
if [ -z "$1" ]; then
    RPC_LIST="$DEFAULT_RPC"
else
    RPC_LIST="$1"
fi

# Convert comma-separated list to array
IFS=',' read -ra RPCS <<< "$RPC_LIST"

echo "🚀 Testing ${#RPCS[@]} RPC(s) for $DURATION seconds each..."
echo "================================================="

# Function to test single RPC
test_rpc() {
    local rpc_url="$1"
    
    # Add http:// if no protocol specified
    if [[ ! "$rpc_url" =~ ^https?:// ]]; then
        rpc_url="http://$rpc_url"
    fi
    
    # Extract display name (keep full URL for display)
    local rpc_display="$rpc_url"
    
    echo -e "\n⏳ Testing RPC: $rpc_url"
    echo "Time       | Latency (ms)"
    echo "--------------------------"
    
    local start_time=$(date +%s)
    local end_time=$((start_time + DURATION))
    local latencies=()
    local successful_requests=0
    local failed_requests=0
    
    while [ "$(date +%s)" -lt "$end_time" ]; do
        local t0=$(date +%s%3N)
        
        # Test RPC with timeout and error handling
        if curl -s -o /dev/null -m 5 -X POST -H "Content-Type: application/json" \
            --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' "$rpc_url" 2>/dev/null; then
            
            local t1=$(date +%s%3N)
            local latency=$((t1 - t0))
            local ts=$(date +%H:%M:%S)
            
            echo "$ts | ${latency} ms"
            latencies+=("$latency")
            ((successful_requests++))
        else
            local ts=$(date +%H:%M:%S)
            echo "$ts | FAILED"
            ((failed_requests++))
        fi
        
        sleep 1
    done
    
    # Calculate statistics only if we have successful requests
    if [ ${#latencies[@]} -gt 0 ]; then
        local min=$(printf '%s\n' "${latencies[@]}" | sort -n | head -n1)
        local max=$(printf '%s\n' "${latencies[@]}" | sort -n | tail -n1)
        local avg=$(printf '%s\n' "${latencies[@]}" | awk '{sum+=$1} END {printf "%.2f", sum/NR}')
        local success_rate=$(awk "BEGIN {printf \"%.1f\", $successful_requests/($successful_requests+$failed_requests)*100}")
        
        echo -e "\n📊 Summary for $rpc_display:"
        echo "➤ Min:          $min ms"
        echo "➤ Max:          $max ms"
        echo "➤ Average:      $avg ms"
        echo "➤ Success rate: $success_rate% ($successful_requests/$((successful_requests+failed_requests)))"
        
        # Return average latency for comparison (multiply by 1000 to avoid floating point in bash)
        echo "${avg%.*}${avg#*.}|$rpc_url|$success_rate" >> /tmp/rpc_results.tmp
    else
        echo -e "\n❌ RPC $rpc_display failed all requests!"
        echo "999999|$rpc_url|0" >> /tmp/rpc_results.tmp
    fi
    
    echo "================================================="
}

# Clean up previous results
rm -f /tmp/rpc_results.tmp

# Test each RPC
for rpc in "${RPCS[@]}"; do
    # Skip empty entries
    if [ -n "$rpc" ]; then
        test_rpc "$rpc"
    fi
done

# Determine best RPC
echo -e "\n🏆 FINAL RESULTS:"
echo "================================================="

if [ -f /tmp/rpc_results.tmp ]; then
    # Sort by average latency (ascending) and success rate (descending)
    # First filter out failed RPCs (success rate > 0), then sort
    working_rpcs=$(grep -v "|0$" /tmp/rpc_results.tmp)
    
    if [ -n "$working_rpcs" ]; then
        best_result=$(echo "$working_rpcs" | sort -t'|' -k1,1n -k3,3nr | head -n1)
        
        avg_latency=$(echo "$best_result" | cut -d'|' -f1)
        best_rpc=$(echo "$best_result" | cut -d'|' -f2)
        success_rate=$(echo "$best_result" | cut -d'|' -f3)
        
        # Convert back to decimal format
        if [ ${#avg_latency} -gt 2 ]; then
            formatted_avg="${avg_latency:0:-2}.${avg_latency: -2}"
        else
            formatted_avg="0.$avg_latency"
        fi
        
        echo "🥇 BEST RPC: $best_rpc"
        echo "➤ Average latency: $formatted_avg ms"
        echo "➤ Success rate: $success_rate%"
        
        # Show all working RPCs ranked
        echo -e "\n📋 Working RPCs ranked by performance:"
        rank=1
        echo "$working_rpcs" | sort -t'|' -k1,1n -k3,3nr | while IFS='|' read -r latency rpc_url success; do
            if [ ${#latency} -gt 2 ]; then
                formatted_lat="${latency:0:-2}.${latency: -2}"
            else
                formatted_lat="0.$latency"
            fi
            echo "$rank. $rpc_url - ${formatted_lat}ms (${success}% success)"
            rank=$((rank + 1))
        done
        
        # Show failed RPCs
        failed_rpcs=$(grep "|0$" /tmp/rpc_results.tmp | cut -d'|' -f2)
        if [ -n "$failed_rpcs" ]; then
            echo -e "\n❌ Failed RPCs:"
            echo "$failed_rpcs" | while IFS= read -r failed_rpc; do
                echo "• $failed_rpc"
            done
        fi
    else
        echo "❌ All RPCs failed!"
        
        echo -e "\n❌ Failed RPCs:"
        cut -d'|' -f2 /tmp/rpc_results.tmp | while IFS= read -r failed_rpc; do
            echo "• $failed_rpc"
        done
    fi
else
    echo "❌ No test results found!"
fi

# Cleanup
rm -f /tmp/rpc_results.tmp

echo "================================================="
