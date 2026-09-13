#!/bin/bash
set -e

# ==============================================================================
# Faurus Exam Browser - macOS One-Line Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/AVPthegreat/faurus-mac/main/install-mac.sh | bash
# ==============================================================================

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${ORANGE}${BOLD}"
echo "    ███████╗ █████╗ ██╗   ██╗██████╗ ██╗   ██╗███████╗"
echo "    ██╔════╝██╔══██╗██║   ██║██╔══██╗██║   ██║██╔════╝"
echo "    █████╗  ███████║██║   ██║██████╔╝██║   ██║███████╗"
echo "    ██╔══╝  ██╔══██║██║   ██║██╔══██╗██║   ██║╚════██║"
echo "    ██║     ██║  ██║╚██████╔╝██║  ██║╚██████╔╝███████║"
echo "    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝"
echo -e "         ${CYAN}Secure Technical Assessment Browser for macOS${NC}\n"

# 1. Check OS
if [[ "$(uname -s)" != "Darwin" ]]; then
    echo -e "${RED}❌ Error: This installer is intended for macOS only.${NC}"
    exit 1
fi

ARCH="$(uname -m)"
echo -e "${CYAN}ℹ️  System:${NC} macOS $(sw_vers -productVersion) (${ARCH})"

# 2. Check if already running and close it
if pgrep -x "Faurus Exam Browser" > /dev/null || pgrep -x "Safe Exam Browser" > /dev/null; then
    echo -e "${ORANGE}⚠️  Faurus Exam Browser is currently running. Closing it...${NC}"
    pkill -x "Faurus Exam Browser" 2>/dev/null || true
    pkill -x "Safe Exam Browser" 2>/dev/null || true
    sleep 1
fi

# 3. Download Latest Release
TEMP_DIR="$(mktemp -d)"
ZIP_PATH="${TEMP_DIR}/Faurus-Exam-Browser.zip"

GITHUB_REPO="AVPthegreat/faurus-mac"
DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/releases/latest/download/Faurus-Exam-Browser.zip"
FALLBACK_URL="https://faurus.app/downloads/Faurus-Exam-Browser.zip"

echo -e "\n${BLUE}⬇️  Downloading latest Faurus Exam Browser...${NC}"

if curl -fSL --progress-bar -o "$ZIP_PATH" "$DOWNLOAD_URL"; then
    echo -e "${GREEN}✓ Download complete from GitHub Releases.${NC}"
else
    echo -e "${ORANGE}⚠️  GitHub Release download failed, trying fallback mirror...${NC}"
    if curl -fSL --progress-bar -o "$ZIP_PATH" "$FALLBACK_URL"; then
        echo -e "${GREEN}✓ Download complete from mirror.${NC}"
    else
        echo -e "${RED}❌ Error: Failed to download Faurus Exam Browser.${NC}"
        echo -e "Please check your internet connection or download manually from: https://github.com/${GITHUB_REPO}/releases"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
fi

# 4. Extract
echo -e "${BLUE}📦 Installing to /Applications...${NC}"
DEST_APP="/Applications/Faurus Exam Browser.app"

# Remove existing installation
if [ -d "$DEST_APP" ]; then
    rm -rf "$DEST_APP"
fi

# Extract into /Applications
unzip -q "$ZIP_PATH" -d "/Applications/"

# 5. Remove Gatekeeper Quarantine
echo -e "${BLUE}🛡️  Configuring macOS Gatekeeper permissions...${NC}"
xattr -cr "$DEST_APP"

# Cleanup temp files
rm -rf "$TEMP_DIR"

echo -e "\n${GREEN}${BOLD}🎉 Installation Successful!${NC}"
echo -e "${GREEN}Faurus Exam Browser has been installed to:${NC} ${BOLD}${DEST_APP}${NC}\n"

# 6. Prompt to Launch
if [ -t 0 ]; then
    read -p "Would you like to open Faurus Exam Browser now? [Y/n] " response
    response=${response:-Y}
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}🚀 Launching Faurus Exam Browser...${NC}"
        open "$DEST_APP"
    fi
else
    echo -e "${CYAN}To launch, open Spotlight (Cmd+Space) and search for 'Faurus Exam Browser'.${NC}"
fi
