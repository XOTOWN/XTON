#!/usr/bin/env python3
"""
XOTown Clique extraData Generator

This script generates the extraData field for Clique PoA genesis block.
ExtraData format:
  - 32 bytes: vanity data (zeros)
  - N * 20 bytes: validator addresses (without 0x prefix)
  - 65 bytes: seal suffix (zeros)

Usage:
  python3 generate_extradata.py <validator1_address> <validator2_address> ...

Example:
  python3 generate_extradata.py 0x1234...5678 0xabcd...ef01
"""

import sys

def generate_extradata(validator_addresses):
    """
    Generate Clique extraData from validator addresses

    Args:
        validator_addresses: List of Ethereum addresses (with or without 0x prefix)

    Returns:
        Complete extraData hex string with 0x prefix
    """
    # Remove 0x prefix if present and validate
    clean_addresses = []
    for addr in validator_addresses:
        addr = addr.lower().strip()
        if addr.startswith('0x'):
            addr = addr[2:]

        if len(addr) != 40:
            raise ValueError(f"Invalid address length: {addr} (must be 40 hex characters)")

        try:
            int(addr, 16)  # Validate hex
        except ValueError:
            raise ValueError(f"Invalid hex address: {addr}")

        clean_addresses.append(addr)

    # Build extraData components
    vanity = '0' * 64  # 32 bytes of zeros
    validators = ''.join(clean_addresses)  # Concatenate all validator addresses
    seal = '0' * 130  # 65 bytes of zeros

    extradata = '0x' + vanity + validators + seal

    return extradata

def main():
    if len(sys.argv) < 2:
        print(__doc__)
        print("\nError: Please provide at least one validator address")
        sys.exit(1)

    validator_addresses = sys.argv[1:]

    try:
        extradata = generate_extradata(validator_addresses)

        print("=" * 80)
        print("XOTown Clique ExtraData Generator")
        print("=" * 80)
        print(f"\nNumber of validators: {len(validator_addresses)}")
        print("\nValidator addresses:")
        for i, addr in enumerate(validator_addresses, 1):
            addr_display = addr if addr.startswith('0x') else '0x' + addr
            print(f"  {i}. {addr_display}")

        print(f"\nGenerated extraData:")
        print(f"  {extradata}")
        print(f"\nLength: {len(extradata)} characters ({(len(extradata)-2)//2} bytes)")
        print("\nYou can now use this extraData in your genesis.json file.")
        print("=" * 80)

    except ValueError as e:
        print(f"\nError: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()
