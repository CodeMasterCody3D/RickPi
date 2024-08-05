#!/bin/bash

RPITX_DIR="$HOME/rpitx"
REPO_DIR="$HOME/RickPi"
RICK_SCRIPT="$REPO_DIR/rick.sh"
DEST_RICK_SCRIPT="$RPITX_DIR/rick.sh"
START_SCRIPT="$REPO_DIR/startroll.sh"
STOP_SCRIPT="$REPO_DIR/stoproll.sh"
DEST_START_SCRIPT="$HOME/startroll.sh"
DEST_STOP_SCRIPT="$HOME/stoproll.sh"

# Function to install dependencies
install_dependencies() {
    echo "Installing dependencies..."
    sudo apt-get update
    sudo apt-get install -y sox screen
}

# Function to install rpitx
install_rpitx() {
    if [ ! -d "$RPITX_DIR" ]; then
        echo "RPiTX is not installed. Installing now..."
        git clone https://github.com/F5OEO/rpitx.git "$RPITX_DIR"
        cd "$RPITX_DIR"
        sudo ./install.sh
    else
        echo "RPiTX is already installed."
    fi
}

# Function to copy scripts to appropriate directories
install_rickroll_modification() {
    # Copy rick.sh to $HOME/rpitx
    echo "Copying rick.sh..."
    cp "$RICK_SCRIPT" "$DEST_RICK_SCRIPT"

    # Copy startroll.sh and stoproll.sh to $HOME
    echo "Copying startroll.sh and stoproll.sh..."
    cp "$START_SCRIPT" "$DEST_START_SCRIPT"
    cp "$STOP_SCRIPT" "$DEST_STOP_SCRIPT"

    # Set permissions and ownership
    echo "Setting permissions and ownership..."
    sudo chown "$USER:$USER" "$DEST_RICK_SCRIPT" "$DEST_START_SCRIPT" "$DEST_STOP_SCRIPT"
    chmod +x "$DEST_RICK_SCRIPT" "$DEST_START_SCRIPT" "$DEST_STOP_SCRIPT"

    echo "Installation complete."
}

# Main script execution
install_dependencies
install_rpitx
install_rickroll_modification
