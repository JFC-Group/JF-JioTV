#!/bin/bash

# Detect the shell
SHELL_NAME=$(basename "$SHELL")

case "$SHELL_NAME" in
    "bash")
        echo "Bash shell detected"
        ;;
    "zsh")
        echo "Zsh shell detected"
        ;;
    "fish")
        echo "Fish shell detected"
        ;;
    *)
        echo "Unsupported shell: $SHELL_NAME"
        exit 1
        ;;
esac

# Step 1: Identify the operating system
OS=""
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "linux-musl" ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "linux-android" ]]; then
    OS="android"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="darwin"
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

echo "Step 1: Identified operating system as $OS"

# Step 2: Identify processor architecture
ARCH=$(uname -m)
case $ARCH in
    "x86_64")
        ARCH="amd64"
        ;;
    "aarch64")
        ARCH="arm64"
        ;;
    "i386" | "i686")
        ARCH="386"
        ;;
    "armv7l")
        ARCH="arm"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "Step 2: Identified processor architecture as $ARCH"

# Step 3: Fetch the latest binary
BINARY_URL="https://api.github.com/repos/rabilrbl/jiotv_go/releases/latest/download/jiotv_go-$OS-$ARCH"
echo "Step 3: Fetching the latest binary from $BINARY_URL"
curl -SL --progress-bar --retry 5 --retry-delay 2 -o jiotv_go "$BINARY_URL" || { echo "Failed to download binary"; exit 1; }

# Step 4: Give executable permissions
chmod +x jiotv_go
echo "Step 4: Granted executable permissions to the binary"

# Step 5: Move binary to $HOME/.jiotv_go
if [[ ! -d "$HOME/.jiotv_go" ]]; then
    mkdir -p "$HOME/.jiotv_go"
fi
mv jiotv_go "$HOME/.jiotv_go/"
echo "Step 5: Moved the binary to $HOME/.jiotv_go/"

# Step 6: Add $HOME/.jiotv_go to PATH
case "$SHELL_NAME" in
    "bash")
        echo "export PATH=$PATH:$HOME/.jiotv_go" >> "$HOME/.bashrc"  # Adjust this line for your shell
        source "$HOME/.bashrc"  # Adjust this line for your shell
        ;;
    "zsh")
        echo "export PATH=$PATH:$HOME/.jiotv_go" >> "$HOME/.zshrc"
        source "$HOME/.zshrc"
        ;;
    "fish")
        echo "set -gx PATH $PATH $HOME/.jiotv_go" >> "$HOME/.config/fish/config.fish"
        source "$HOME/.config/fish/config.fish"
        ;;
    *)
        echo "Unsupported shell: $SHELL_NAME"
        exit 1
        ;;
esac

# Step 7: Inform the user
echo "JioTV Go has successfully installed. Start by running jiotv_go help"
