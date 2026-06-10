#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

ZAP_URL="https://raw.githubusercontent.com/via80HD/zap/main/zap"
INSTALL_DIR="$HOME/.local/bin"
ZAP_PATH="$INSTALL_DIR/zap"

echo "====================================="
echo "        ZAP INSTALLER STARTED        "
echo "====================================="
echo

# --- helper: detect package manager ---
detect_pkg_manager() {
    if command -v apt >/dev/null 2>&1; then
        echo "apt"
    elif command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v pacman >/dev/null 2>&1; then
        echo "pacman"
    elif command -v zypper >/dev/null 2>&1; then
        echo "zypper"
    else
        echo ""
    fi
}

# --- helper: auto install package ---
ensure_package() {
    local pkg="$1"
    if command -v "$pkg" >/dev/null 2>&1; then
        echo "✔ $pkg is already installed."
        return
    fi

    echo "⚙ '$pkg' is missing. Attempting automatic installation..."
    local pm
    pm="$(detect_pkg_manager)"

    if [ -z "$pm" ]; then
        echo "❌ Error: Could not detect a supported package manager."
        echo "Please install '$pkg' manually and re-run this script."
        exit 1
    fi

    case "$pm" in
        apt)
            sudo apt update -y && sudo apt install -y "$pkg"
            ;;
        dnf)
            sudo dnf install -y "$pkg"
            ;;
        pacman)
            sudo pacman -Sy --noconfirm "$pkg"
            ;;
        zypper)
            sudo zypper install -y "$pkg"
            ;;
    esac
    echo "✔ Successfully installed $pkg."
}

# --- 1. Check Dependencies ---
echo "[1/5] Checking environment dependencies..."
ensure_package "curl"
ensure_package "python3"

# --- 2. Ensure Install Directory Exists ---
echo
echo "[2/5] Ensuring install directory exists: $INSTALL_DIR"
# Force-create directory path ensuring ownership matches current user
mkdir -p "$INSTALL_DIR"
echo "✔ Install directory ready."

# --- 3. Download Zap ---
echo
echo "[3/5] Downloading zap..."
echo "From: $ZAP_URL"
echo "To:   $ZAP_PATH"
curl -fsSL "$ZAP_URL" -o "$ZAP_PATH"
echo "✔ Download complete."

# --- 4. Make Executable ---
echo
echo "[4/5] Setting executable permissions..."
chmod +x "$ZAP_PATH"
echo "✔ Permissions set."

# --- 5. Ensure PATH contains ~/.local/bin ---
echo
echo "[5/5] Configuring PATH..."
case ":$PATH:" in
    *":$INSTALL_DIR:"*)
        echo "✔ $INSTALL_DIR is already in your PATH."
        ;;
    *)
        # Identify the user's active login shell configuration file
        SHELL_RC="$HOME/.bashrc"
        if [ -f "$HOME/.zshrc" ]; then
            SHELL_RC="$HOME/.zshrc"
        elif [ -f "$HOME/.profile" ]; then
            SHELL_RC="$HOME/.profile"
        fi

        echo "Adding $INSTALL_DIR to PATH in $SHELL_RC..."
        # Append without asking to handle curl | bash clean pipelines
        echo "" >> "$SHELL_RC"
        echo "# Zap CLI installation path update" >> "$SHELL_RC"
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_RC"
        echo "✔ Added to $SHELL_RC."
        echo
        echo "👉 To use zap immediately in this terminal session, run:"
        echo "   source $SHELL_RC"
        ;;
esac

echo
echo "====================================="
echo "          ZAP IS INSTALLED!          "
echo "====================================="
echo "Try opening a new terminal or source your config file, then type:"
echo "  zap info"
