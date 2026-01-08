#!/usr/bin/env bash

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

install_package() {
    local pkg="$1"
    local pm
    pm="$(detect_pkg_manager)"

    if [ -z "$pm" ]; then
        echo "Could not detect a supported package manager."
        echo "Please install '$pkg' manually and re-run this installer."
        exit 1
    fi

    echo
    read -r -p "'$pkg' is not installed. Install it now with sudo $pm? (y/n): " ans
    case "$ans" in
        y|Y)
            echo
            echo "Installing $pkg using $pm..."
            case "$pm" in
                apt)
                    sudo apt update && sudo apt install -y "$pkg"
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
            ;;
        *)
            echo "Cannot continue without '$pkg'. Exiting."
            exit 1
            ;;
    esac
}

# --- check curl ---
echo "[1/6] Checking for curl..."
if ! command -v curl >/dev/null 2>&1; then
    install_package "curl"
else
    echo "curl is present."
fi

# --- check unzip (optional, but ready for future use) ---
echo
echo "[2/6] Checking for unzip..."
if ! command -v unzip >/dev/null 2>&1; then
    install_package "unzip"
else
    echo "unzip is present."
fi

# --- ensure install dir exists ---
echo
echo "[3/6] Ensuring install directory exists: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
echo "Install directory ready."

# --- download zap ---
echo
echo "[4/6] Downloading zap..."
echo "From: $ZAP_URL"
echo "To:   $ZAP_PATH"
curl -fsSL "$ZAP_URL" -o "$ZAP_PATH"
echo "Download complete."

# --- make executable ---
echo
echo "[5/6] Setting executable permissions..."
chmod +x "$ZAP_PATH"
echo "Permissions set."

# --- ensure PATH contains ~/.local/bin ---
echo
echo "[6/6] Checking PATH for $INSTALL_DIR..."
case ":$PATH:" in
    *":$INSTALL_DIR:"*)
        echo "$INSTALL_DIR is already in PATH."
        ;;
    *)
        echo "$INSTALL_DIR is not in PATH."
        SHELL_RC="$HOME/.bashrc"

        if [ -f "$HOME/.zshrc" ] && [ -n "$ZSH_VERSION" ]; then
            SHELL_RC="$HOME/.zshrc"
        fi

        echo
        read -r -p "Add $INSTALL_DIR to PATH in $SHELL_RC? (y/n): " ans
        case "$ans" in
            y|Y)
                echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_RC"
                echo "Added to $SHELL_RC."
                echo
                echo "To apply it now, run:"
                echo "  source \"$SHELL_RC\""
                ;;
            *)
                echo "Skipping PATH modification. You must add $INSTALL_DIR to PATH manually."
                ;;
        esac
        ;;
esac

echo
echo "====================================="
echo "         ZAP IS INSTALLED!           "
echo "====================================="
echo
echo "Try running: zap info"
