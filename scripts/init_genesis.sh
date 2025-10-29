#!/bin/bash

# XOTown Genesis Initialization Script
# This script initializes 5 validator nodes with the XOTown genesis block

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
XOTOWN_DIR="$HOME/xotown-nodes"
GENESIS_FILE="$(pwd)/core/genesis/xotown_mainnet.json"
XOTOWN_BINARY="$(pwd)/build/bin/xotown"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}XOTown Genesis Initialization${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if xotown binary exists
if [ ! -f "$XOTOWN_BINARY" ]; then
    echo -e "${RED}Error: xotown binary not found at $XOTOWN_BINARY${NC}"
    echo -e "${YELLOW}Please build xotown first: make xotown${NC}"
    exit 1
fi

# Check if genesis file exists
if [ ! -f "$GENESIS_FILE" ]; then
    echo -e "${RED}Error: Genesis file not found at $GENESIS_FILE${NC}"
    exit 1
fi

# Create directory structure
echo -e "${YELLOW}Creating directory structure...${NC}"
mkdir -p "$XOTOWN_DIR"

for i in {1..5}; do
    NODE_DIR="$XOTOWN_DIR/node$i"
    mkdir -p "$NODE_DIR"
    echo -e "  Created: $NODE_DIR"
done

# Initialize each node with genesis
echo -e "\n${YELLOW}Initializing nodes with genesis block...${NC}"
for i in {1..5}; do
    NODE_DIR="$XOTOWN_DIR/node$i"
    echo -e "\n${GREEN}Initializing Node $i...${NC}"
    "$XOTOWN_BINARY" --datadir "$NODE_DIR" init "$GENESIS_FILE"
done

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}Genesis initialization complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\nNode directories created at: $XOTOWN_DIR"
echo -e "\nNext steps:"
echo -e "  1. Create validator accounts for each node"
echo -e "  2. Generate extraData with validator addresses"
echo -e "  3. Update genesis.json with real addresses"
echo -e "  4. Re-initialize nodes"
echo -e "  5. Start nodes with start_nodes.sh"
echo ""
