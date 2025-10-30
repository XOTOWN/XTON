# Join XOTown Network

Welcome to XOTown! This guide will help you set up a node and connect to the XOTown Mainnet.

## Prerequisites

- **Operating System**: Linux (Ubuntu 20.04+), macOS, or Windows (WSL2)
- **Hardware**:
  - CPU: 2+ cores
  - RAM: 4GB minimum, 8GB recommended
  - Storage: 50GB SSD (grows over time)
  - Network: Stable internet connection with open P2P port
- **Software**:
  - Go 1.23+ (if building from source)
  - Git (if building from source)

---

## Option 1: Download Pre-built Binary (Recommended)

### Step 1: Download XOTown

```bash
# Create directory
mkdir -p ~/xotown && cd ~/xotown

# Download latest release (replace VERSION with actual version)
wget https://github.com/xotown/xotown-chain/releases/download/VERSION/xotown-linux-amd64.tar.gz

# Extract
tar -xzf xotown-linux-amd64.tar.gz

# Make executable
chmod +x xotown
```

### Step 2: Download Genesis File

```bash
# Download the official genesis file
wget https://raw.githubusercontent.com/xotown/xotown-chain/main/core/genesis/xotown_mainnet.json
```

### Step 3: Initialize Node

```bash
# Initialize with genesis
./xotown init xotown_mainnet.json
```

### Step 4: Start Your Node

```bash
# Start syncing with the network
./xotown --networkid 29090 \
  --bootnodes "enode://YOUR_BOOTNODE_ENODE_HERE@IP:30303" \
  --syncmode "snap" \
  --http \
  --http.addr "127.0.0.1" \
  --http.port 8545 \
  --http.api "eth,net,web3" \
  --ws \
  --ws.addr "127.0.0.1" \
  --ws.port 8546 \
  --ws.api "eth,net,web3"
```

**Note**: Replace `YOUR_BOOTNODE_ENODE_HERE@IP:30303` with actual bootnode information provided by XOTown.

---

## Option 2: Build from Source

### Step 1: Install Go

```bash
# Ubuntu/Debian
wget https://go.dev/dl/go1.23.2.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.23.2.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc

# Verify installation
go version
```

### Step 2: Clone and Build

```bash
# Clone repository
git clone https://github.com/xotown/xotown-chain.git
cd xotown-chain

# Checkout stable branch
git checkout xotown-v1.15.11

# Build
make xotown

# Binary location
./build/bin/xotown version
```

### Step 3: Initialize and Run

```bash
# Download genesis
wget https://raw.githubusercontent.com/xotown/xotown-chain/main/core/genesis/xotown_mainnet.json

# Initialize
./build/bin/xotown init xotown_mainnet.json

# Start node (same command as Option 1, Step 4)
```

---

## Network Configuration

### Bootnode Information

**Primary Bootnode**:
```
enode://[BOOTNODE_ID]@[BOOTNODE_IP]:30303
```

*Official bootnode information will be updated here after mainnet launch.*

### Network Details

| Parameter | Value |
|-----------|-------|
| Network ID | 29090 |
| Chain ID | 29090 |
| P2P Port | 30303 (default) |
| RPC Port | 8545 (default) |
| WS Port | 8546 (default) |

### Firewall Configuration

```bash
# Ubuntu/Debian with UFW
sudo ufw allow 30303/tcp
sudo ufw allow 30303/udp

# CentOS/RHEL with firewalld
sudo firewall-cmd --permanent --add-port=30303/tcp
sudo firewall-cmd --permanent --add-port=30303/udp
sudo firewall-cmd --reload
```

---

## Verify Your Node

### Check Sync Status

```bash
# Attach to console
./xotown attach

# In console, check sync status
> eth.syncing

# Check current block
> eth.blockNumber

# Check peer count
> net.peerCount

# Check connected peers
> admin.peers

# Exit console
> exit
```

### Load XOTown Extensions

```javascript
// In xotown console
loadScript("console/xotown.js")

// Check network info
xotown.info()

// Verify you're on XOTown mainnet
xotown.isXOTown()  // Should return true
```

---

## Create an Account

```bash
# Create new account
./xotown account new

# You'll be prompted for a password
# Save the address and password securely!

# List accounts
./xotown account list
```

**Important**:
- Back up your keystore file (located in `~/.xotown/keystore/`)
- Never share your private key or password
- Keep multiple backups in secure locations

---

## Advanced Configuration

### Run as Background Service (Linux)

Create systemd service file:

```bash
sudo nano /etc/systemd/system/xotown.service
```

Add the following:

```ini
[Unit]
Description=XOTown Node
After=network.target

[Service]
Type=simple
User=YOUR_USERNAME
ExecStart=/home/YOUR_USERNAME/xotown/xotown \
  --networkid 29090 \
  --bootnodes "enode://YOUR_BOOTNODE_ENODE@IP:30303" \
  --syncmode "snap" \
  --http \
  --http.addr "127.0.0.1" \
  --http.port 8545 \
  --http.api "eth,net,web3" \
  --ws \
  --ws.addr "127.0.0.1" \
  --ws.port 8546 \
  --ws.api "eth,net,web3"
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable xotown
sudo systemctl start xotown

# Check status
sudo systemctl status xotown

# View logs
sudo journalctl -u xotown -f
```

### Optimize Performance

```bash
# Increase file descriptors
ulimit -n 65536

# Add to ~/.bashrc for persistence
echo 'ulimit -n 65536' >> ~/.bashrc

# For systemd service, add to [Service] section:
# LimitNOFILE=65536
```

---

## Connect MetaMask

1. Open MetaMask
2. Click network dropdown → "Add Network"
3. Fill in the details:

```
Network Name: XOTown Mainnet
RPC URL: https://rpc.xotown.com (or your local: http://localhost:8545)
Chain ID: 29090
Currency Symbol: XOTN
Block Explorer URL: https://explorer.xotown.com (when available)
```

4. Click "Save"

---

## Troubleshooting

### Node Won't Start

```bash
# Check if port is in use
sudo netstat -tulpn | grep 30303

# Check genesis hash matches
./xotown attach --exec "eth.getBlock(0).hash"
# Should return: 0x... (official genesis hash)

# Remove old data and reinitialize
rm -rf ~/.xotown/geth
./xotown init xotown_mainnet.json
```

### No Peers Connecting

1. Check firewall settings
2. Verify bootnode enode is correct
3. Check internet connectivity
4. Try adding peers manually:

```javascript
// In console
admin.addPeer("enode://PEER_ENODE@IP:30303")
```

### Sync is Slow

- Use `--syncmode "snap"` for faster initial sync
- Ensure you have sufficient bandwidth
- Check disk I/O performance (SSD recommended)
- Increase cache size: `--cache 4096`

### Check Logs

```bash
# If running in foreground
# Logs appear in terminal

# If running as service
sudo journalctl -u xotown -f

# If running with custom log file
tail -f ~/xotown/xotown.log
```

---

## Getting XOTN Tokens

### For Testing
- Join our Discord for testnet faucet tokens
- Discord: [discord.gg/xotown](https://discord.gg/xotown)

### For Mainnet
- Register on [xotown.com](https://xotown.com) and participate in activities
- Exchange listings (coming soon)
- Earn by creating valuable content (Steps)

---

## Next Steps

✅ **Join the Community**
- Discord: [discord.gg/xotown](https://discord.gg/xotown)
- Telegram: [t.me/xotown](https://t.me/xotown)

✅ **Explore the Platform**
- Visit [xotown.com](https://xotown.com)
- Leave your first Step
- Create your virtual house

✅ **For Developers**
- Read [API Reference](API_REFERENCE.md)
- Check [Smart Contract Guide](CONTRACTS.md)
- Consider becoming a [Validator](VALIDATOR_GUIDE.md)

---

## Support

If you encounter issues:

1. Check this guide thoroughly
2. Search existing [GitHub Issues](https://github.com/xotown/xotown-chain/issues)
3. Ask in [Discord](https://discord.gg/xotown) #support channel
4. Email: support@xotown.com

---

**Welcome to the XOTown Network! 🎉**
