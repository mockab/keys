#!/bin/bash

# Define variables
GITHUB_USERNAME="mockab"
SSH_DIR="$HOME/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"
SSH_CONFIG="/etc/ssh/sshd_config"

# Function to download SSH keys from GitHub
download_ssh_keys() {
    echo "Downloading SSH keys from GitHub..."
    curl -s "https://github.com/$GITHUB_USERNAME.keys" -o "$AUTHORIZED_KEYS"
    if [[ $? -ne 0 ]]; then
        echo "Failed to download SSH keys from GitHub. Please check your username and internet connection."
        exit 1
    fi
}

# Function to ensure SSH directory exists and set correct permissions
setup_ssh_directory() {
    echo "Setting up .ssh directory..."
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
}

# Function to set permissions for the authorized_keys file
set_authorized_keys_permissions() {
    echo "Setting permissions for authorized_keys file..."
    chmod 600 "$AUTHORIZED_KEYS"
}

# Function to enable public key authentication in sshd_config
enable_public_key_authentication() {
    echo "Enabling public key authentication..."
    if grep -q "PubkeyAuthentication yes" "$SSH_CONFIG"; then
        echo "Public key authentication is already enabled."
    else
        echo "PubkeyAuthentication yes" | sudo tee -a "$SSH_CONFIG"
    fi
    sudo systemctl restart sshd
}

# Main script execution
setup_ssh_directory
download_ssh_keys
set_authorized_keys_permissions
enable_public_key_authentication

echo "SSH keys installed and public key authentication enabled successfully."
