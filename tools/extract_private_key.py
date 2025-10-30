#!/usr/bin/env python3
"""
Extract private key from Ethereum keystore file
Usage: python3 extract_private_key.py <keystore_file_path> <password>
"""

import sys
import json
from getpass import getpass
from eth_account import Account

def extract_private_key(keystore_path, password):
    """Extract private key from keystore file"""
    try:
        # Read keystore file
        with open(keystore_path, 'r') as f:
            keystore = json.load(f)

        # Decrypt private key
        private_key = Account.decrypt(keystore, password)

        # Convert to hex
        private_key_hex = private_key.hex()

        # Get address
        account = Account.from_key(private_key)
        address = account.address

        return address, private_key_hex

    except FileNotFoundError:
        print(f"Error: Keystore file not found: {keystore_path}")
        return None, None
    except ValueError as e:
        print(f"Error: Incorrect password or invalid keystore format")
        return None, None
    except Exception as e:
        print(f"Error: {str(e)}")
        return None, None

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 extract_private_key.py <keystore_file_path> [password]")
        print("\nExample:")
        print("  python3 extract_private_key.py ~/xotown-setup/master/keystore/UTC--2024-...")
        print("\nIf password is not provided, you will be prompted to enter it securely.")
        sys.exit(1)

    keystore_path = sys.argv[1]

    # Get password
    if len(sys.argv) >= 3:
        password = sys.argv[2]
    else:
        password = getpass("Enter keystore password: ")

    print(f"\nExtracting private key from: {keystore_path}")
    print("=" * 80)

    address, private_key = extract_private_key(keystore_path, password)

    if address and private_key:
        print(f"\n✅ Successfully extracted private key!\n")
        print(f"Address:     {address}")
        print(f"Private Key: 0x{private_key}")
        print("\n⚠️  WARNING: Keep this private key SECRET and SECURE!")
        print("   Never share it or commit it to git!")
        print("=" * 80)
    else:
        print("\n❌ Failed to extract private key")
        sys.exit(1)

if __name__ == "__main__":
    main()
