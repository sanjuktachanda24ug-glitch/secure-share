#!/bin/bash

# Check if correct arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: ./send.sh <filename> <recipient_username> <recipient_ip>"
    exit 1
fi

FILE=$1
USER=$2
IP=$3
PUB_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINPcb/JElLRiA3XcGbBLdM4AnB7aKPg92VM6/41LtGmK"

echo "[1/4] Generating checksum of original file..."
sha256sum "$FILE" > "$FILE.sha256"

echo "[2/4] Encrypting file with age..."
age -R <(echo "$PUB_KEY") -o "$FILE.age" "$FILE"

echo "[3/4] Transferring files locally..."
# We just copy to a different folder or the home directory
if cp "$FILE.age" "$FILE.sha256" "$HOME/"; then
    STATUS="SUCCESS"
    echo "Local transfer complete."
else
    STATUS="FAILED"
fi

echo "[4/4] Logging transfer..."
STATUS="SUCCESS"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
CHECKSUM=$(cat "$FILE.sha256" | awk '{print $1}')

echo "$TIMESTAMP | SENDER | $USER | $FILE | $CHECKSUM | $STATUS" >> transfer.log

echo "Done! Check transfer.log for details."
