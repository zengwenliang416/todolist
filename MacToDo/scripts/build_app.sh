#!/bin/bash
set -euo pipefail

APP_NAME="MacToDo"
BUILD_DIR=".build/release"
APP_BUNDLE="$APP_NAME.app"
DMG_NAME="$APP_NAME.dmg"
LOG_FILE=${LOG_FILE:-"build_app.log"}

mkdir -p "$(dirname "$LOG_FILE")"
echo -e "\n===== $(date '+%Y-%m-%d %H:%M:%S') Start build =====" | tee -a "$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1

# Generate Logo
echo "🎨 Generating Logo..."
if [ -f "scripts/generate_logo.py" ]; then
    command -v python3 >/dev/null 2>&1 && python3 scripts/generate_logo.py || echo "⚠️ python3 未找到，跳过生成"
fi

# Convert to icns
echo "🖼️ Creating AppIcon.icns..."
if [ -d "Resources/MacToDo.iconset" ]; then
    if command -v iconutil >/dev/null 2>&1; then
        iconutil -c icns Resources/MacToDo.iconset -o Resources/AppIcon.icns
    else
        echo "⚠️ iconutil 未找到，跳过 icns 转换"
    fi
fi

echo "🚀 Building $APP_NAME..."
swift build -c release --product MacToDo

echo "📦 Creating App Bundle..."
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

# Copy binary
cp "$BUILD_DIR/$APP_NAME" "$APP_BUNDLE/Contents/MacOS/"

# Copy Info.plist
if [ -f "Sources/Config/Info.plist" ]; then
    cp "Sources/Config/Info.plist" "$APP_BUNDLE/Contents/Info.plist"
else
    echo "⚠️ Info.plist not found, generating minimal one..."
    cat > "$APP_BUNDLE/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>MacToDo</string>
    <key>CFBundleIdentifier</key>
    <string>com.example.mactodo</string>
    <key>CFBundleName</key>
    <string>MacToDo</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>12.0</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
</dict>
</plist>
PLIST
fi

# Set Icon
if [ -f "Resources/AppIcon.icns" ]; then
    cp "Resources/AppIcon.icns" "$APP_BUNDLE/Contents/Resources/"
fi

echo "🔨 Signing..."
codesign --force --deep --sign - "$APP_BUNDLE"
codesign --verify --deep --strict "$APP_BUNDLE" || echo "⚠️ codesign 验证失败（开发环境可忽略）"

echo "💿 Creating DMG..."
rm -f "$DMG_NAME"
hdiutil create -volname "$APP_NAME" -srcfolder "$APP_BUNDLE" -ov -format UDZO "$DMG_NAME"

if command -v shasum >/dev/null 2>&1; then
    echo "🧮 Calculating SHA256..."
    shasum -a 256 "$DMG_NAME" | awk '{print $1}' > "$DMG_NAME.sha256"
else
    echo "⚠️ shasum 未找到，跳过 SHA256 计算"
fi

echo "✅ Done! App is at $APP_BUNDLE and Installer is $DMG_NAME"
echo "===== Build finished ====="
