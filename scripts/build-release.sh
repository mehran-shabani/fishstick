#!/bin/bash

# Script to build release APK and App Bundle
# Usage: ./scripts/build-release.sh

set -e

echo "🔨 Building Release Artifacts"
echo "==============================="

# Get current version
VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | sed 's/+.*//')
BUILD_NUMBER=$(grep '^version:' pubspec.yaml | sed 's/.*+//')

echo "Version: $VERSION"
echo "Build: $BUILD_NUMBER"
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Build APK
echo ""
echo "📱 Building APK..."
flutter build apk --release

# Build App Bundle
echo ""
echo "📦 Building App Bundle..."
flutter build appbundle --release

echo ""
echo "✅ Build completed successfully!"
echo ""
echo "Output files:"
echo "  APK: build/app/outputs/flutter-apk/app-release.apk"
echo "  AAB: build/app/outputs/bundle/release/app-release.aab"
echo ""

# Calculate file sizes
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
  APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
  echo "APK Size: $APK_SIZE"
fi

if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
  AAB_SIZE=$(du -h build/app/outputs/bundle/release/app-release.aab | cut -f1)
  echo "AAB Size: $AAB_SIZE"
fi
