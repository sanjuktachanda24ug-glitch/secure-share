# Secure File Sharing Tool
[cite_start]A simple, secure command-line system to encrypt, transfer, and verify files for human rights investigations[cite: 1, 2].

## Setup Instructions
1. [cite_start]**Key Generation**: Run `./setup_keys.sh` to generate your Ed25519 SSH keys[cite: 59].
2. **Key Distribution**: Share your public key (`id_ed25519.pub`) with the sender. [cite_start]Keep your private key secret[cite: 61, 62].
3. [cite_start]**Passwordless Login**: Use `ssh-copy-id` to enable key-based login to the SSH server[cite: 60].

## How to Run
### Sender Side
To encrypt and send a file:
`./send.sh <filename> <recipient_ssh_public_key> <remote_host>`

### Receiver Side
To decrypt and verify a file:
`./receive.sh <encrypted_file> <private_key>`

## Example Commands
```bash
# Encrypting and sending
./send.sh report.pdf "ssh-ed25519 AAA..." bob@192.168.1.10

# Expected Output:
# [SUCCESS] Checksum generated.
# [SUCCESS] File encrypted with age.
# [SUCCESS] Transfer complete.
