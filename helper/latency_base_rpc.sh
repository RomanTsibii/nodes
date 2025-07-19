#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/latency_base_rpc.sh) YOU_RPC 
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/latency_base_rpc.sh) 

RPC_URL="${1:-https://mainnet.base.org}"
DURATION=20  # duration in seconds

echo "⏳ Testing RPC: $RPC_URL for $DURATION seconds..."
echo "Time       | Latency (ms)"
echo "--------------------------"

start_time=$(date +%s)
end_time=$((start_time + DURATION))

latencies=()

while [ "$(date +%s)" -lt "$end_time" ]; do
    t0=$(date +%s%3N)
    curl -s -o /dev/null -X POST -H "Content-Type: application/json" \
        --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' "$RPC_URL"
    t1=$(date +%s%3N)

    latency=$((t1 - t0))
    ts=$(date +%H:%M:%S)
    echo "$ts | ${latency} ms"
    latencies+=("$latency")
    sleep 1
done

# Calculate statistics
min=$(printf '%s\n' "${latencies[@]}" | sort -n | head -n1)
max=$(printf '%s\n' "${latencies[@]}" | sort -n | tail -n1)
avg=$(printf '%s\n' "${latencies[@]}" | awk '{sum+=$1} END {printf "%.2f", sum/NR}')

echo -e "\n📊 Summary:"
echo "➤ Min:    $min ms"
echo "➤ Max:    $max ms"
echo "➤ Average:$avg ms"
