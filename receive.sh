#!/bin/bash

# Usage: ./receive.sh <encrypted_file> <checksum_file> <private_key>
if [ "$#" -ne 3 ]; then
    echo "Usage: ./receive.sh <encrypted_file> <checksum_file> <private_key_path>"
    exit 1
fi

ENCRYPTED_FILE=$1
CHECKSUM_FILE=$2
PRIVATE_KEY=$3
DECRYPTED_FILE="decrypted_notes.txt"

echo "[1/3] Decrypting file with private key..."
# age -d (decrypt) -i (identity/private key)
if age -d -i "$PRIVATE_KEY" -o "$DECRYPTED_FILE" "$ENCRYPTED_FILE"; then
    echo "Decryption successful."
else
    echo "ERROR: Decryption failed. Did you use the right private key?"
    exit 1
fi

echo "[2/3] Verifying Integrity (Checksum)..."
# We extract the hash from the .sha256 file and compare it to the new file
EXPECTED_HASH=$(cat "$CHECKSUM_FILE" | awk '{print $1}')
ACTUAL_HASH=$(sha256sum "$DECRYPTED_FILE" | awk '{print $1}')

if [ "$EXPECTED_HASH" == "$ACTUAL_HASH" ]; then
    echo "[3/3] RESULT: SUCCESS! Hashes match. Data is authentic."
else
    echo "[3/3] RESULT: FAILED! Hash mismatch. The file may have been tampered with."
    exit 1
fi
