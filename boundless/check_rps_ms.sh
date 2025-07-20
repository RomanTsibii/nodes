#!/bin/bash
# Usage: bash rpc_monitor.sh rpc1,rpc2,rpc3
# Continuously monitors RPC performance and updates .env.broker with best RPC
# USING 
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/boundless/check_rps_ms.sh) rpc1,rpc2,rpc3....

ENV_FILE="$HOME/boundless/.env.broker"
TEST_DURATION=5  # Test each RPC for 5 seconds
CYCLE_PAUSE=10   # Pause between full test cycles

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default RPC if none provided
DEFAULT_RPC="https://mainnet.base.org"

# Parse input RPCs
if [ -z "$1" ]; then
    echo -e "${RED}❌ Please provide RPC URLs separated by commas${NC}"
    echo "Usage: $0 rpc1,rpc2,rpc3"
    exit 1
fi

RPC_LIST="$1"
IFS=',' read -ra RPCS <<< "$RPC_LIST"

echo -e "${BLUE}🚀 Starting continuous RPC monitoring (READ-ONLY)...${NC}"
echo -e "${BLUE}📁 Checking environment file: $ENV_FILE${NC}"
echo -e "${BLUE}🔍 Will monitor and recommend optimal RPC${NC}"
echo -e "${BLUE}🔄 Testing ${#RPCS[@]} RPC(s) every $(($TEST_DURATION * ${#RPCS[@]} + $CYCLE_PAUSE)) seconds${NC}"
echo -e "${BLUE}⏱️  Each RPC tested for $TEST_DURATION seconds${NC}"
echo "================================================="

# Function to get current RPC from env file
get_current_rpc() {
    if [ -f "$ENV_FILE" ]; then
        grep "^export RPC_URL=" "$ENV_FILE" | sed 's/export RPC_URL="\(.*\)"/\1/'
    else
        echo ""
    fi
}

# Function to check if current RPC is optimal
check_rpc_recommendation() {
    local current_rpc="$1"
    local best_rpc="$2"
    local best_latency="$3"
    local current_latency="$4"
    local current_success="$5"
    
    if [ "$current_rpc" = "$best_rpc" ]; then
        echo -e "${GREEN}✅ CURRENT RPC IS OPTIMAL${NC}"
        echo -e "${GREEN}➤ Your current RPC is the best performer${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  RECOMMENDATION: CONSIDER CHANGING RPC${NC}"
        echo -e "${YELLOW}➤ Current: $current_rpc (${current_latency}ms)${NC}"
        echo -e "${YELLOW}➤ Better option: $best_rpc (${best_latency}ms)${NC}"
        
        # Calculate improvement percentage
        local current_lat_num="${current_latency%.*}${current_latency#*.}"
        local best_lat_num="${best_latency%.*}${best_latency#*.}"
        if [ "$current_lat_num" -gt 0 ] && [ "$best_lat_num" -gt 0 ]; then
            local improvement=$(awk "BEGIN {printf \"%.1f\", ($current_lat_num-$best_lat_num)/$current_lat_num*100}")
            echo -e "${YELLOW}➤ Potential improvement: ${improvement}% faster${NC}"
        fi
        return 1
    fi
}

# Function to test single RPC
test_rpc() {
    local rpc_url="$1"
    
    # Add http:// if no protocol specified
    if [[ ! "$rpc_url" =~ ^https?:// ]]; then
        rpc_url="http://$rpc_url"
    fi
    
    local start_time=$(date +%s)
    local end_time=$((start_time + TEST_DURATION))
    local latencies=()
    local successful_requests=0
    local failed_requests=0
    
    # Display message to stderr so it doesn't interfere with return data
    echo -n -e "${YELLOW}Testing $rpc_url... ${NC}" >&2
    
    while [ "$(date +%s)" -lt "$end_time" ]; do
        local t0=$(date +%s%3N)
        
        # Test RPC with timeout
        if curl -s -o /dev/null -m 3 -X POST -H "Content-Type: application/json" \
            --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' "$rpc_url" 2>/dev/null; then
            
            local t1=$(date +%s%3N)
            local latency=$((t1 - t0))
            latencies+=("$latency")
            ((successful_requests++))
        else
            ((failed_requests++))
        fi
        
        sleep 1
    done
    
    if [ ${#latencies[@]} -gt 0 ]; then
        local min=$(printf '%s\n' "${latencies[@]}" | sort -n | head -n1)
        local max=$(printf '%s\n' "${latencies[@]}" | sort -n | tail -n1)
        local avg=$(printf '%s\n' "${latencies[@]}" | awk '{sum+=$1} END {printf "%.2f", sum/NR}')
        local success_rate=$(awk "BEGIN {printf \"%.1f\", $successful_requests/($successful_requests+$failed_requests)*100}")
        
        # Display result to stderr
        echo -e "${GREEN}✅ ${avg}ms avg (${success_rate}% success)${NC}" >&2
        
        # Return data: avg_latency_int|rpc_url|success_rate|formatted_avg
        local avg_int="${avg%.*}${avg#*.}"
        echo "$avg_int|$rpc_url|$success_rate|$avg"
    else
        # Display result to stderr
        echo -e "${RED}❌ FAILED${NC}" >&2
        echo "999999|$rpc_url|0|9999.99"
    fi
}

# Function to perform full test cycle
test_cycle() {
    local cycle_num="$1"
    echo -e "\n${BLUE}🔄 Test Cycle #$cycle_num - $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo "================================================="
    
    # Get current RPC
    local current_rpc=$(get_current_rpc)
    if [ -n "$current_rpc" ]; then
        echo -e "${BLUE}📍 Current RPC: $current_rpc${NC}"
    else
        echo -e "${YELLOW}📍 No RPC currently set in $ENV_FILE${NC}"
    fi
    
    echo ""
    
    # Test all RPCs
    local results=()
    for rpc in "${RPCS[@]}"; do
        if [ -n "$rpc" ]; then
            local result=$(test_rpc "$rpc")
            results+=("$result")
        fi
    done
    
    # Find best RPC (working ones only)
    local working_results=()
    for result in "${results[@]}"; do
        local success_rate=$(echo "$result" | cut -d'|' -f3)
        if [ "$success_rate" != "0" ]; then
            working_results+=("$result")
        fi
    done
    
    if [ ${#working_results[@]} -gt 0 ]; then
        # Sort by latency (ascending)
        local best_result=$(printf '%s\n' "${working_results[@]}" | sort -t'|' -k1,1n | head -n1)
        
        local best_latency_int=$(echo "$best_result" | cut -d'|' -f1)
        local best_rpc=$(echo "$best_result" | cut -d'|' -f2)
        local best_success=$(echo "$best_result" | cut -d'|' -f3)
        local best_latency_formatted=$(echo "$best_result" | cut -d'|' -f4)
        
        echo ""
        echo -e "${GREEN}🏆 BEST PERFORMING RPC: $best_rpc${NC}"
        echo -e "${GREEN}➤ Latency: ${best_latency_formatted}ms (${best_success}% success)${NC}"
        
        # Check current RPC performance and make recommendation
        if [ -n "$current_rpc" ]; then
            # Find current RPC in results
            local current_result=""
            local current_found=false
            for result in "${working_results[@]}"; do
                local rpc_url=$(echo "$result" | cut -d'|' -f2)
                if [ "$rpc_url" = "$current_rpc" ]; then
                    current_result="$result"
                    current_found=true
                    break
                fi
            done
            
            if [ "$current_found" = true ]; then
                local current_latency_formatted=$(echo "$current_result" | cut -d'|' -f4)
                local current_success_rate=$(echo "$current_result" | cut -d'|' -f3)
                
                echo ""
                check_rpc_recommendation "$current_rpc" "$best_rpc" "$best_latency_formatted" "$current_latency_formatted" "$current_success_rate"
            else
                echo ""
                echo -e "${RED}❌ CURRENT RPC NOT WORKING${NC}"
                echo -e "${RED}➤ Your current RPC ($current_rpc) failed all tests${NC}"
                echo -e "${YELLOW}➤ Recommended: Switch to $best_rpc (${best_latency_formatted}ms)${NC}"
            fi
        else
            echo ""
            echo -e "${YELLOW}ℹ️  NO CURRENT RPC SET${NC}"
            echo -e "${YELLOW}➤ Recommended: Set RPC_URL=\"$best_rpc\" in $ENV_FILE${NC}"
        fi
        

        
    else
        echo -e "${RED}❌ All RPCs failed! No recommendations available.${NC}"
        if [ -n "$current_rpc" ]; then
            echo -e "${RED}➤ Your current RPC ($current_rpc) is also not working${NC}"
        fi
    fi
    
    echo "================================================="
    echo -e "${BLUE}💤 Waiting $CYCLE_PAUSE seconds before next cycle...${NC}"
}

# Trap Ctrl+C to exit gracefully
trap 'echo -e "\n${YELLOW}🛑 Monitoring stopped by user${NC}"; exit 0' INT

# Main monitoring loop
cycle_count=1
while true; do
    test_cycle $cycle_count
    sleep $CYCLE_PAUSE
    ((cycle_count++))
done
