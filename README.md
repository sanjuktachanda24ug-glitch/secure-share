
# Secure File Sharing Tool

A simple, secure command-line system to encrypt, transfer, and verify files for human rights investigations. This tool ensures that sensitive data remains confidential during transit and is verified for integrity upon receipt.

---

## Setup Instructions

### 1. Key Generation

Generate your Ed25519 SSH key pair (this creates a public and private key):

```bash
ssh-keygen -t ed25519 -f ./id_ed25519 -N ""
```

### 2. Key Distribution & Authentication

- Share your public key (`id_ed25519.pub`) with the sender.
- Keep your private key (`id_ed25519`) **secret**.

To enable local testing/transfer, add the public key to your authorized keys:

```bash
mkdir -p ~/.ssh
cat id_ed25519.pub >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
```

---

## How to Run

### 1. Sender Side (`send.sh`)

This script generates a SHA-256 checksum, encrypts the file using the recipient's public key, and transfers the package.

**Command:**

```bash
chmod +x send.sh
./send.sh <filename> <recipient_username> <recipient_ip>
```

**Example:**

```bash
./send.sh notes.txt sanjukta_chanda24_ug_apu_edu_in localhost
```

### 2. Receiver Side (`receive.sh`)

This script decrypts the file using the recipient's private key and performs an integrity check by comparing the original and current checksums.

**Command:**

```bash
chmod +x receive.sh
./receive.sh <encrypted_file.age> <checksum_file.sha256> <private_key_path>
```

**Example:**

```bash
./receive.sh notes.txt.age notes.txt.sha256 id_ed25519
```

---

## Technical Specifications

| Feature | Details |
|---|---|
| **Encryption Engine** | Built using `age` (modern replacement for GPG) with SSH-Ed25519 public keys |
| **Integrity Verification** | Uses `sha256sum` to detect any data tampering — if even one bit changes, the receiver script flags a failure |
| **Logging** | All transactions are appended to `transfer.log` with a timestamp, file hash, and status (`SUCCESS`/`FAILED`) |

---

## Implementation & Troubleshooting Notes

**SCP vs. CP:**
The script is designed for `scp` (Secure Copy over SSH). During testing in restricted lab environments, a local `cp` fallback was implemented to demonstrate successful automation logic without triggering network permission errors.

**Security Guardrails:**
The `.gitignore` file is configured to exclude the private key (`id_ed25519`) and data files (`.age`, `.sha256`) to ensure that only the tool logic is shared, maintaining operational security.

---

## Expected Success Output

**Sender:**
Sender: [SUCCESS] Checksum generated | [SUCCESS] File encrypted | Transfer complete.
Receiver: Decryption successful | RESULT: SUCCESS! Hashes match. Data is authentic
