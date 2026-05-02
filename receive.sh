#!/bin/bash

# Usage: ./receive.sh <encrypted_file> <checksum_file> <private_key_path>
FILE_AGE=$1
FILE_SHA=$2
KEY=$3

echo "[1/3] Decrypting file with private key..."
# This removes the .age extension for the output name
OUTPUT_NAME=$(basename "$FILE_AGE" .age)
age -d -i "$KEY" -o "decrypted_$OUTPUT_NAME" "$FILE_AGE"

echo "[2/3] Verifying Integrity (Checksum)..."
# We check the decrypted file against the original hash
# Note: This assumes the .sha256 was made from the original file
echo "$(cat $FILE_SHA | awk '{print $1}')  decrypted_$OUTPUT_NAME" | sha256sum -c

if [ $? -eq 0 ]; then
    echo "[3/3] Result: SUCCESS. File is authentic and untampered."
else
    echo "[3/3] Result: FAILED. File may be corrupted or tampered with!"
fi
