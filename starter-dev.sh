#!/bin/bash
set -e

# Colors for terminal output
BOLD="\033[1m"
GREEN="\033[0;32m"
ORANGE="\033[38;5;208m"
CYAN="\033[0;36m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${BOLD}${ORANGE}====================================================${RESET}"
echo -e "${BOLD}${ORANGE}       FAURUS EXAM BROWSER — DEV LAUNCHER           ${RESET}"
echo -e "${BOLD}${ORANGE}====================================================${RESET}"
echo ""

# 1. Verify Xcode Developer Directory
DEVELOPER_DIR=$(xcode-select -p 2>/dev/null || echo "")
if [[ "$DEVELOPER_DIR" == *"CommandLineTools"* ]] || [[ -z "$DEVELOPER_DIR" ]]; then
    if [ -d "/Applications/Xcode.app" ]; then
        echo -e "${CYAN}==> Pointing active developer directory to Xcode.app...${RESET}"
        sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
    else
        echo -e "${RED}[ERROR] Xcode.app was not found in /Applications.${RESET}"
        echo -e "Please ensure Xcode finishes downloading and installing before running this script."
        exit 1
    fi
fi

echo -e "${GREEN}✓ Xcode toolchain detected:${RESET} $(xcode-select -p)"
echo ""

# 2. Build in Debug Configuration
echo -e "${CYAN}==> Compiling Faurus Exam Browser in Development Mode (DEBUG=1)...${RESET}"
echo -e "    • Prohibited apps termination: ${GREEN}DISABLED${RESET}"
echo -e "    • Screenshots & Recording:     ${GREEN}ALLOWED${RESET}"
echo -e "    • Dock, Menu Bar, Cmd+Tab:     ${GREEN}ACTIVE${RESET}"
echo -e "    • Window Mode:                 ${GREEN}RESIZABLE (80%)${RESET}"
echo ""

xcodebuild -workspace SafeExamBrowser.xcworkspace \
           -scheme "Safe Exam Browser" \
           -configuration Debug \
           -derivedDataPath ./build \
           build -quiet

BUILD_DIR="./build/Build/Products/Debug"
APP_PATH=$(find "$BUILD_DIR" -maxdepth 2 -name "*.app" | head -n 1)

if [ -z "$APP_PATH" ] || [ ! -d "$APP_PATH" ]; then
    echo -e "${RED}[ERROR] Build succeeded but .app bundle was not found in $BUILD_DIR.${RESET}"
    exit 1
fi

echo -e "${GREEN}✓ Build succeeded!${RESET}"
echo -e "  App Bundle: ${BOLD}$APP_PATH${RESET}"
echo ""

# 3. Strip quarantine if any
xattr -cr "$APP_PATH" 2>/dev/null || true

# 4. Launch the App
echo -e "${CYAN}==> Launching Faurus Exam Browser in Development Mode...${RESET}"
open "$APP_PATH"

echo ""
echo -e "${BOLD}${GREEN}Faurus Exam Browser is now running!${RESET}"
echo -e "You can test side-by-side without closing any of your open apps."
