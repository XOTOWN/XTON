#!/bin/bash

# XOTown 5-Node Startup Script
# Starts 5 XOTown validator nodes on a single server

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
XOTOWN_DIR="$HOME/xotown-nodes"
XOTOWN_BINARY="$(pwd)/build/bin/xotown"
PASSWORD_FILE="$XOTOWN_DIR/password.txt"
NETWORK_ID="29090"

# Port configurations
declare -A P2P_PORTS=([1]=30303 [2]=30304 [3]=30305 [4]=30306 [5]=30307)
declare -A RPC_PORTS=([1]=8545 [2]=8546 [3]=8547 [4]=8548 [5]=8549)
declare -A WS_PORTS=([1]=8546 [2]=8547 [3]=8548 [4]=8549 [5]=8550)

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}XOTown 5-Node Network Startup${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if xotown binary exists
if [ ! -f "$XOTOWN_BINARY" ]; then
    echo -e "${RED}Error: xotown binary not found${NC}"
    exit 1
fi

# Check if password file exists
if [ ! -f "$PASSWORD_FILE" ]; then
    echo -e "${YELLOW}Warning: Password file not found at $PASSWORD_FILE${NC}"
    echo -e "${YELLOW}Creating empty password file...${NC}"
    touch "$PASSWORD_FILE"
    chmod 600 "$PASSWORD_FILE"
fi

# Start Node 1 (Bootnode)
echo -e "${GREEN}Starting Node 1 (Bootnode + Validator)...${NC}"
NODE1_DIR="$XOTOWN_DIR/node1"
"$XOTOWN_BINARY" --datadir "$NODE1_DIR" \
    --networkid "$NETWORK_ID" \
    --port ${P2P_PORTS[1]} \
    --http --http.addr "127.0.0.1" --http.port ${RPC_PORTS[1]} \
    --http.api "eth,net,web3,personal,admin,miner,clique" \
    --http.corsdomain "*" \
    --ws --ws.addr "127.0.0.1" --ws.port ${WS_PORTS[1]} \
    --ws.api "eth,net,web3,personal,admin,miner,clique" \
    --ws.origins "*" \
    --allow-insecure-unlock \
    --unlock "0" \
    --password "$PASSWORD_FILE" \
    --mine \
    --miner.etherbase "0" \
    --syncmode "full" \
    --maxpeers 50 \
    > "$XOTOWN_DIR/node1.log" 2>&1 &

NODE1_PID=$!
echo -e "  PID: $NODE1_PID"
echo -e "  P2P: ${P2P_PORTS[1]}, RPC: ${RPC_PORTS[1]}, WS: ${WS_PORTS[1]}"

# Wait for Node 1 to start and get enode
sleep 5

# Get Node 1 enode URL
BOOTNODE_ENODE=$("$XOTOWN_BINARY" attach --exec "admin.nodeInfo.enode" "$NODE1_DIR/xotown.ipc" 2>/dev/null | tr -d '"' || echo "")

if [ -z "$BOOTNODE_ENODE" ]; then
    echo -e "${RED}Error: Could not get bootnode enode${NC}"
    exit 1
fi

echo -e "  Bootnode enode: $BOOTNODE_ENODE"

# Start Nodes 2-5
for i in {2..5}; do
    echo -e "\n${GREEN}Starting Node $i (Validator)...${NC}"
    NODE_DIR="$XOTOWN_DIR/node$i"

    "$XOTOWN_BINARY" --datadir "$NODE_DIR" \
        --networkid "$NETWORK_ID" \
        --port ${P2P_PORTS[$i]} \
        --http --http.addr "127.0.0.1" --http.port ${RPC_PORTS[$i]} \
        --http.api "eth,net,web3,personal,admin,miner,clique" \
        --http.corsdomain "*" \
        --ws --ws.addr "127.0.0.1" --ws.port ${WS_PORTS[$i]} \
        --ws.api "eth,net,web3,personal,admin,miner,clique" \
        --ws.origins "*" \
        --allow-insecure-unlock \
        --unlock "0" \
        --password "$PASSWORD_FILE" \
        --mine \
        --miner.etherbase "0" \
        --syncmode "full" \
        --bootnodes "$BOOTNODE_ENODE" \
        --maxpeers 50 \
        > "$XOTOWN_DIR/node$i.log" 2>&1 &

    NODE_PID=$!
    echo -e "  PID: $NODE_PID"
    echo -e "  P2P: ${P2P_PORTS[$i]}, RPC: ${RPC_PORTS[$i]}, WS: ${WS_PORTS[$i]}"
    sleep 2
done

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}All 5 nodes started successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\nNode logs:"
for i in {1..5}; do
    echo -e "  Node $i: $XOTOWN_DIR/node$i.log"
done

echo -e "\nRPC Endpoints:"
for i in {1..5}; do
    echo -e "  Node $i: http://localhost:${RPC_PORTS[$i]}"
done

echo -e "\nCheck status:"
echo -e "  ./scripts/monitor_nodes.sh"
echo -e "\nStop all nodes:"
echo -e "  ./scripts/stop_nodes.sh"
echo ""
