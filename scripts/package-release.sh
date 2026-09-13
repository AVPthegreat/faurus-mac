#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="${PROJECT_DIR}/dist"
APP_NAME="Faurus Exam Browser"
APP_PATH="${PROJECT_DIR}/DerivedData/Build/Products/Release/${APP_NAME}.app"

if [ ! -d "$APP_PATH" ]; then
    APP_PATH="${HOME}/Library/Developer/Xcode/DerivedData/SafeExamBrowser-gazahhtgkzrztianbtovpwoyggaq/Build/Products/Release/${APP_NAME}.app"
fi

if [ ! -d "$APP_PATH" ]; then
    echo "❌ Error: Could not find ${APP_NAME}.app at $APP_PATH"
    echo "   Please run a Release build first."
    exit 1
fi

echo "📦 Found: $APP_PATH"
mkdir -p "$DIST_DIR"

# 1. Create ZIP
ZIP_PATH="${DIST_DIR}/Faurus-Exam-Browser.zip"
echo "🗜️ Creating ZIP: $ZIP_PATH ..."
rm -f "$ZIP_PATH"
ditto -c -k --sequesterRsrc --keepParent "$APP_PATH" "$ZIP_PATH"
echo "✅ ZIP created ($(du -h "$ZIP_PATH" | cut -f1))"

# 2. Create DMG
DMG_PATH="${DIST_DIR}/Faurus-Exam-Browser.dmg"
DMG_TEMP="${DIST_DIR}/temp_dmg"
echo "💿 Creating DMG: $DMG_PATH ..."
rm -rf "$DMG_TEMP" "$DMG_PATH"
mkdir -p "$DMG_TEMP"

cp -R "$APP_PATH" "$DMG_TEMP/"
ln -s /Applications "$DMG_TEMP/Applications"

hdiutil create -volname "${APP_NAME}" \
               -srcfolder "$DMG_TEMP" \
               -ov -format UDZO \
               "$DMG_PATH"

rm -rf "$DMG_TEMP"
echo "✅ DMG created ($(du -h "$DMG_PATH" | cut -f1))"

echo ""
echo "🎉 Packaging Complete!"
echo "   - DMG: $DMG_PATH"
echo "   - ZIP: $ZIP_PATH"
