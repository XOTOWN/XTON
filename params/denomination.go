// Copyright 2017 The go-ethereum Authors
// This file is part of the go-ethereum library.
//
// The go-ethereum library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The go-ethereum library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the go-ethereum library. If not, see <http://www.gnu.org/licenses/>.

package params

// These are the multipliers for ether denominations.
// Example: To get the wei value of an amount in 'gwei', use
//
//	new(big.Int).Mul(value, big.NewInt(params.GWei))
//
// XOTown Network Denomination System:
// The XOTown network uses custom denomination names based on XOTN coin.
//
// Standard Ethereum names are maintained for compatibility,
// but XOTown-specific names are also defined:
//
//   Ethereum Name  |  XOTown Name  |  Value (in Woti)
//   ---------------|---------------|------------------
//   Wei            |  Woti         |  1
//   KWei           |  KWoti        |  1,000 (10^3)
//   MWei           |  MWoti        |  1,000,000 (10^6)
//   GWei           |  GWoti        |  1,000,000,000 (10^9)
//   Szabo          |  -            |  10^12
//   Finney         |  -            |  10^15
//   Ether          |  XOTN         |  1,000,000,000,000,000,000 (10^18)
//
// Total Supply: 1,000,000,000,000 XOTN = 10^30 Woti (1조 XOTN, 선채굴)
//
// Usage in XOTown:
//   web3.fromWoti(balance, "xotn")  // Instead of web3.fromWei(balance, "ether")
//   web3.fromWoti(balance, "gwoti") // Instead of web3.fromWei(balance, "gwei")
const (
	// Standard Ethereum denominations (for compatibility)
	Wei   = 1
	GWei  = 1e9
	Ether = 1e18

	// XOTown-specific denominations
	Woti  = 1     // Base unit (equivalent to Wei)
	KWoti = 1e3   // Kilo Woti (1,000 Woti)
	MWoti = 1e6   // Mega Woti (1,000,000 Woti)
	GWoti = 1e9   // Giga Woti (1,000,000,000 Woti) - equivalent to GWei
	XOTN  = 1e18  // 1 XOTN = 10^18 Woti (equivalent to Ether)
)
