#!/bin/bash

# XOTown Node Stop Script
# Safely stops all running XOTown nodes

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}Stopping XOTown Nodes${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

# Find and kill xotown processes
XOTOWN_PIDS=$(ps aux | grep '[x]otown' | grep -v grep | awk '{print $2}')

if [ -z "$XOTOWN_PIDS" ]; then
    echo -e "${GREEN}No running xotown processes found.${NC}"
    exit 0
fi

echo -e "${YELLOW}Found running xotown processes:${NC}"
ps aux | grep '[x]otown' | grep -v grep

echo ""
echo -e "${YELLOW}Sending SIGTERM to processes...${NC}"

for PID in $XOTOWN_PIDS; do
    echo -e "  Stopping PID $PID..."
    kill -TERM $PID 2>/dev/null || true
done

# Wait for processes to terminate
sleep 5

# Check if processes are still running
REMAINING=$(ps aux | grep '[x]otown' | grep -v grep | wc -l)

if [ "$REMAINING" -gt 0 ]; then
    echo -e "\n${YELLOW}Some processes still running. Sending SIGKILL...${NC}"
    for PID in $(ps aux | grep '[x]otown' | grep -v grep | awk '{print $2}'); do
        echo -e "  Force killing PID $PID..."
        kill -9 $PID 2>/dev/null || true
    done
    sleep 2
fi

# Final check
FINAL_CHECK=$(ps aux | grep '[x]otown' | grep -v grep | wc -l)

if [ "$FINAL_CHECK" -eq 0 ]; then
    echo -e "\n${GREEN}========================================${NC}"
    echo -e "${GREEN}All XOTown nodes stopped successfully!${NC}"
    echo -e "${GREEN}========================================${NC}"
else
    echo -e "\n${RED}========================================${NC}"
    echo -e "${RED}Warning: Some processes may still be running${NC}"
    echo -e "${RED}========================================${NC}"
    ps aux | grep '[x]otown' | grep -v grep
fi

echo ""
