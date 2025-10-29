#!/bin/bash

# XOTown Node Monitoring Script
# Displays real-time status of all 5 nodes

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

XOTOWN_DIR="$HOME/xotown-nodes"
XOTOWN_BINARY="$(pwd)/build/bin/xotown"

# Clear screen
clear

while true; do
    # Move cursor to top
    tput cup 0 0

    echo -e "${GREEN}========================================================================================================${NC}"
    echo -e "${GREEN}                              XOTown Network Monitor - $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${GREEN}========================================================================================================${NC}"
    echo ""

    # Check if nodes are running
    RUNNING_NODES=$(ps aux | grep '[x]otown' | grep -v grep | wc -l)
    if [ "$RUNNING_NODES" -eq 0 ]; then
        echo -e "${RED}No XOTown nodes are currently running.${NC}"
        echo -e "${YELLOW}Start nodes with: ./scripts/start_nodes.sh${NC}"
        echo ""
        sleep 5
        continue
    fi

    echo -e "${BLUE}Running Nodes: $RUNNING_NODES / 5${NC}"
    echo ""
    echo -e "${YELLOW}Node Status:${NC}"
    printf "%-8s %-12s %-10s %-10s %-20s\n" "Node" "Block #" "Peers" "Mining" "Balance (XOTN)"
    echo "------------------------------------------------------------------------------------------------"

    for i in {1..5}; do
        NODE_DIR="$XOTOWN_DIR/node$i"
        IPC="$NODE_DIR/xotown.ipc"

        if [ ! -S "$IPC" ]; then
            printf "%-8s ${RED}%-12s %-10s %-10s %-20s${NC}\n" "Node $i" "OFFLINE" "-" "-" "-"
            continue
        fi

        # Get block number
        BLOCK=$("$XOTOWN_BINARY" attach --exec "eth.blockNumber" "$IPC" 2>/dev/null || echo "?")

        # Get peer count
        PEERS=$("$XOTOWN_BINARY" attach --exec "net.peerCount" "$IPC" 2>/dev/null || echo "?")

        # Get mining status
        MINING=$("$XOTOWN_BINARY" attach --exec "eth.mining" "$IPC" 2>/dev/null || echo "?")
        if [ "$MINING" == "true" ]; then
            MINING_STATUS="${GREEN}YES${NC}"
        else
            MINING_STATUS="${RED}NO${NC}"
        fi

        # Get balance of first account
        ACCOUNT=$("$XOTOWN_BINARY" attach --exec "eth.accounts[0]" "$IPC" 2>/dev/null | tr -d '"' || echo "")
        if [ -n "$ACCOUNT" ]; then
            BALANCE_WEI=$("$XOTOWN_BINARY" attach --exec "eth.getBalance('$ACCOUNT')" "$IPC" 2>/dev/null || echo "0")
            BALANCE=$("$XOTOWN_BINARY" attach --exec "web3.fromWei($BALANCE_WEI, 'ether')" "$IPC" 2>/dev/null || echo "0")
        else
            BALANCE="0"
        fi

        printf "%-8s %-12s %-10s " "Node $i" "$BLOCK" "$PEERS"
        echo -e "$MINING_STATUS        $BALANCE"
    done

    echo ""
    echo -e "${YELLOW}Latest Blocks:${NC}"
    # Show latest block from Node 1
    NODE1_IPC="$XOTOWN_DIR/node1/xotown.ipc"
    if [ -S "$NODE1_IPC" ]; then
        LATEST_BLOCK=$("$XOTOWN_BINARY" attach --exec "eth.getBlock('latest')" "$NODE1_IPC" 2>/dev/null || echo "{}")
        echo "$LATEST_BLOCK" | python3 -m json.tool 2>/dev/null | head -20 || echo "Unable to fetch block info"
    fi

    echo ""
    echo -e "${YELLOW}Press Ctrl+C to exit${NC}"
    echo -e "${GREEN}========================================================================================================${NC}"

    # Refresh every 5 seconds
    sleep 5
done
