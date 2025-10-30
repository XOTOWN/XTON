# XOTown Blockchain

**A GIS-based Social Network Powered by Blockchain Technology**

[![License: LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0)
[![Go Version](https://img.shields.io/badge/Go-1.23%2B-00ADD8?logo=go)](https://golang.org/)
[![Network](https://img.shields.io/badge/Network-XOTown%20Mainnet-green)](https://xotown.com)

## Overview

XOTown is a revolutionary blockchain network that powers **xotown.com**, a location-based social platform where geography meets community. Built on a customized Ethereum protocol, XOTown enables users to create, share, and own their digital presence tied to real-world locations.

### The XOTown Ecosystem

**xotown.com** combines the best of location-based services and social networking with blockchain technology:

- **📍 Steps**: Leave location-based messages called "Steps" at specific geographic coordinates
- **🏠 Digital Housing**: Create and customize your personal virtual space, inspired by the legendary SayClub housing system
- **👥 Social Interactions**: Invite friends to your house, visit others, and build a vibrant community
- **🌍 Real-World Integration**: Explore the world through user-generated content tied to actual locations
- **💎 True Ownership**: All digital assets, houses, and content are secured by blockchain technology

### Why Blockchain?

XOTown leverages blockchain to provide:

- ✅ **True Digital Ownership**: Users own their houses, decorations, and content as NFTs
- ✅ **Decentralized Platform**: No single point of control or censorship
- ✅ **Transparent Economy**: XOTN coin powers all in-platform transactions
- ✅ **Interoperability**: Assets can be traded, transferred, and used across platforms
- ✅ **Community Governance**: Token holders participate in platform decisions

---

## Network Specifications

| Parameter | Value |
|-----------|-------|
| **Coin Name** | XOTN (XOTown Coin) |
| **Network Name** | XOTown Mainnet |
| **Chain ID** | 29090 |
| **Consensus** | Clique PoA (Proof of Authority) |
| **Block Time** | 3 seconds |
| **Total Supply** | 1,000,000,000,000 XOTN (1 trillion, pre-mined) |
| **Block Reward** | 0 XOTN (fixed supply) |
| **Base Unit** | Woti (10¹⁸ Woti = 1 XOTN) |

---

## Key Features

### 🚀 High Performance
- **3-second block time** for near-instant transactions
- Optimized for high-throughput social interactions
- Efficient GIS data processing on-chain

### 🔒 Enterprise-Grade Security
- Clique PoA consensus with trusted validators
- Pre-audited codebase based on go-ethereum v1.15.11
- Regular security updates and monitoring

### 🌐 Location-Based Smart Contracts
- Native support for geographic coordinates
- Location-verified content creation
- Spatial indexing for efficient queries

### 💰 Unique Denomination System
- **Woti**: Base unit (like Wei)
- **GWoti**: Giga Woti (10⁹)
- **XOTN**: Main coin unit (10¹⁸ Woti)

Custom naming convention designed for the XOTown ecosystem.

---

## Quick Start

### For Regular Users (Join the Network)

```bash
# Download the latest release
wget https://github.com/XOTOWN/XTON/releases/latest/download/xotown-linux-amd64.tar.gz

# Extract and make it executable
tar -xzf xotown-linux-amd64.tar.gz
chmod +x xotown

# Download genesis file
wget https://raw.githubusercontent.com/XOTOWN/XTON/main/core/genesis/xotown_mainnet.json

# Initialize your node
./xotown init xotown_mainnet.json

# Start your node (bootnode info will be provided after mainnet launch)
./xotown --networkid 29090 \
  --bootnodes "enode://[BOOTNODE_INFO_PROVIDED_AFTER_LAUNCH]@[IP]:30303" \
  --syncmode "snap"
```

**Note**: Official bootnode information will be announced on our [Discord](https://discord.gg/xotown) after mainnet launch.

### For Developers (Build from Source)

```bash
# Clone the repository
git clone https://github.com/XOTOWN/XTON.git
cd XTON

# Switch to the stable branch
git checkout xotown-v1.15.11

# Build XOTown
make xotown

# The binary will be at build/bin/xotown
./build/bin/xotown version
```

**Requirements**: Go 1.23+ ([installation guide](https://golang.org/doc/install))

---

## Use Cases

### For Users
- **Leave Your Mark**: Drop "Steps" (messages) at meaningful locations
- **Build Your Home**: Create and decorate your virtual house
- **Social Discovery**: Find and interact with nearby users
- **Collect Memories**: Own your location-based content forever

### For Developers
- **Build Location Dapps**: Create apps using XOTown's GIS features
- **NFT Marketplaces**: Trade houses, decorations, and collectibles
- **Social Protocols**: Develop new ways for users to interact
- **Data Analytics**: Analyze location-based social trends

### For Businesses
- **Location Marketing**: Sponsor Steps at key locations
- **Virtual Real Estate**: Develop and sell premium house designs
- **Community Events**: Host virtual gatherings tied to real locations
- **Brand Experiences**: Create immersive location-based campaigns

---

## Architecture

XOTown is built on a customized Ethereum protocol with the following enhancements:

```
┌─────────────────────────────────────────────────┐
│           XOTown Application Layer              │
│         (xotown.com - Social Platform)          │
├─────────────────────────────────────────────────┤
│          Smart Contract Layer                   │
│   (Steps, Houses, NFTs, Social Interactions)    │
├─────────────────────────────────────────────────┤
│          XOTown Blockchain Layer                │
│     (Clique PoA, 3s blocks, XOTN token)        │
├─────────────────────────────────────────────────┤
│      Modified go-ethereum v1.15.11              │
│   (Custom denomination, Network configs)        │
└─────────────────────────────────────────────────┘
```

### Technical Stack

- **Base Protocol**: Ethereum (go-ethereum v1.15.11)
- **Consensus**: Clique PoA (Proof of Authority)
- **Smart Contracts**: Solidity 0.8+
- **API**: JSON-RPC, WebSocket, GraphQL
- **Frontend**: Compatible with Web3.js, ethers.js
- **Wallets**: MetaMask, WalletConnect, Custom

---

## Documentation

- 💰 [XOTN Units](XOTN_UNITS.md) - Denomination system explained
- 🔗 [Join Network](docs/JOIN_NETWORK.md) - How to participate
- 🤝 [Contributing](CONTRIBUTING.md) - Contribution guidelines
- 📜 [License](LICENSE) - LGPL v3.0

---

## Network Roadmap

### Phase 1: Foundation (Q1 2025) ✅
- ✅ Launch XOTown Mainnet with 5 validators
- ✅ Deploy core smart contracts (Steps, Houses)
- ✅ Release xotown.com beta platform
- ✅ Open-source blockchain code

### Phase 2: Growth (Q2 2025)
- 🔄 Expand to 20+ external validators
- 🔄 Launch NFT marketplace for houses/items
- 🔄 Mobile app release (iOS/Android)
- 🔄 Integration with major wallets

### Phase 3: Ecosystem (Q3-Q4 2025)
- ⏳ Developer grants program
- ⏳ Third-party Dapp ecosystem
- ⏳ Cross-chain bridges
- ⏳ DAO governance implementation

### Phase 4: Decentralization (2026)
- ⏳ 100+ validator nodes worldwide
- ⏳ Full community governance
- ⏳ Layer 2 scaling solutions
- ⏳ Global expansion

---

## Token Economics

### XOTN Token Utility

1. **Transaction Fees**: All network operations require XOTN
2. **House Purchases**: Buy and upgrade virtual houses
3. **Premium Features**: Access exclusive platform features
4. **Content Monetization**: Tip creators for great Steps
5. **Governance**: Vote on platform upgrades (future)

### Distribution

```
Total Supply: 1,000,000,000,000 XOTN (Fixed)

├─ Platform Reserve:    40% (400B XOTN) - Development & Operations
├─ Community Rewards:   30% (300B XOTN) - User incentives
├─ Team & Advisors:     15% (150B XOTN) - 4-year vesting
├─ Ecosystem Fund:      10% (100B XOTN) - Grants & Partnerships
└─ Initial Liquidity:    5% (50B XOTN)  - DEX listings
```

---

## Community & Support

### Connect With Us

- 🌐 **Website**: [xotown.com](https://xotown.com)
- 💬 **Discord**: [discord.gg/xotown](https://discord.gg/xotown)
- 🐦 **Twitter**: [@xotown_official](https://twitter.com/xotown_official)
- 📧 **Email**: support@xotown.com
- 📱 **Telegram**: [t.me/xotown](https://t.me/xotown)

### Contributing

We welcome contributions from the community! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## Security

### Responsible Disclosure

If you discover a security vulnerability, please email security@xotown.com. We take security seriously and will respond promptly.

### Bug Bounty Program

We offer rewards for finding critical bugs. Details at [xotown.com/security/bounty](https://xotown.com/security/bounty)

---

## License

XOTown is licensed under the [GNU Lesser General Public License v3.0](LICENSE).

This project is derived from [go-ethereum](https://github.com/ethereum/go-ethereum), which is also licensed under LGPL v3.0.

---

## Credits

### Built On
- **go-ethereum**: The foundation of XOTown blockchain
- **Ethereum Community**: For pioneering blockchain technology
- **Clique Contributors**: For the PoA consensus mechanism

### Inspiration
- **SayClub**: Pioneering virtual housing and social spaces
- **Foursquare/Swarm**: Location-based check-ins
- **Pokémon GO**: Real-world location gaming
- **Decentraland**: Virtual world ownership

---

## Disclaimer

XOTown is experimental technology. While we strive for security and reliability:

- Cryptocurrency carries inherent risks
- Do not invest more than you can afford to lose
- The platform is provided "as is" without warranties
- Past performance does not guarantee future results

Always do your own research (DYOR) before participating.

---

<p align="center">
  <strong>Building the Future of Location-Based Social Networks</strong><br>
  Made with ❤️ by the XOTown Team
</p>

<p align="center">
  <a href="https://xotown.com">Website</a> •
  <a href="docs/JOIN_NETWORK.md">Join Network</a> •
  <a href="CONTRIBUTING.md">Contributing</a> •
  <a href="https://discord.gg/xotown">Discord</a>
</p>
