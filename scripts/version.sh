#!/bin/bash

# Script to manually increment version
# Usage: ./scripts/version.sh

set -e

echo "📦 Version Management Script"
echo "=============================="

# Read current version
CURRENT_VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | sed 's/+.*//')
echo "Current version: $CURRENT_VERSION"

# Parse version components
MAJOR=$(echo "$CURRENT_VERSION" | cut -d. -f1)
MINOR=$(echo "$CURRENT_VERSION" | cut -d. -f2)
PATCH=$(echo "$CURRENT_VERSION" | cut -d. -f3)

echo ""
echo "Select increment type:"
echo "1) Patch (+0.01)  - مثال: 1.0.0 -> 1.0.1"
echo "2) Minor (+0.1)   - مثال: 1.0.0 -> 1.1.0"
echo "3) Major (+1)     - مثال: 1.0.0 -> 2.0.0"
echo "4) Custom version"
read -r -p "Enter choice (1-4): " choice

case $choice in
  1)
    NEW_PATCH=$((PATCH + 1))
    if [ $NEW_PATCH -ge 100 ]; then
      NEW_MINOR=$((MINOR + 1))
      NEW_PATCH=0
      if [ $NEW_MINOR -ge 100 ]; then
        MAJOR=$((MAJOR + 1))
        NEW_MINOR=0
      fi
    else
      NEW_MINOR=$MINOR
    fi
    NEW_VERSION="${MAJOR}.${NEW_MINOR}.${NEW_PATCH}"
    ;;
  2)
    NEW_MINOR=$((MINOR + 1))
    NEW_PATCH=0
    if [ $NEW_MINOR -ge 100 ]; then
      MAJOR=$((MAJOR + 1))
      NEW_MINOR=0
    fi
    NEW_VERSION="${MAJOR}.${NEW_MINOR}.${NEW_PATCH}"
    ;;
  3)
    MAJOR=$((MAJOR + 1))
    NEW_MINOR=0
    NEW_PATCH=0
    NEW_VERSION="${MAJOR}.${NEW_MINOR}.${NEW_PATCH}"
    ;;
  4)
    read -r -p "Enter new version (e.g., 2.1.5): " NEW_VERSION
    ;;
  *)
    echo "Invalid choice!"
    exit 1
    ;;
esac

# Get build number
BUILD_NUMBER=$(git rev-list --count HEAD)
FULL_VERSION="${NEW_VERSION}+${BUILD_NUMBER}"

echo ""
echo "New version: $FULL_VERSION"
read -r -p "Proceed with this version? (y/n): " confirm

if [ "$confirm" != "y" ]; then
  echo "Cancelled."
  exit 0
fi

# Update pubspec.yaml
sed -i.bak "s/^version: .*/version: ${FULL_VERSION}/" pubspec.yaml
rm -f pubspec.yaml.bak

echo "✅ Version updated to $FULL_VERSION"
echo ""
echo "Next steps:"
echo "1. git add pubspec.yaml"
echo "2. git commit -m 'chore: bump version to $FULL_VERSION'"
echo "3. git tag v${NEW_VERSION}"
echo "4. git push && git push --tags"
