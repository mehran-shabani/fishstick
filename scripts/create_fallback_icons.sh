#!/bin/bash
# Create minimal fallback PNG icons for pre-v26 Android devices

# Base64 of a simple 48x48 blue square PNG
ICON_BASE64="iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAA7AAAAOwBeShxvQAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAEPSURBVGiB7dk9CsJAFIXhLzFYWbiCFHYuQNzAVq5gZW8hbkHcgJW1lY2FhYWFhYWFhYVgISIkJjOTzLyZc+B2Ceb7eTMvMwkAAAAAAAAAAAAAAAAAAOADM8yyLGuZWRZCCPO+t9ba27Is2xBCmNd1Xe+6rvvqe/um6/qqrus6hBDmJUny1Pf2Tdv2z0mSPItIXlXVWwhhXpZlMfR5f5VlWQwhhHlVVW8ikte2bRdCCPOyLIuh7+03WZbF0Pf2o23bhYjkVVVtQwhhXpZlMfT9/ZZlWQwhhHlVVVsRyfO+t29t274mSfIkInnX67UQkbwsyyKEMG/b9q3v7Zuu13MRyQEAAAAAAAAAAAAAAAAAfuYDXdZFj+XB/z4AAAAASUVORK5CYII="

# Create directory structure
mkdir -p android/app/src/main/res/{mipmap-mdpi,mipmap-hdpi,mipmap-xhdpi,mipmap-xxhdpi,mipmap-xxxhdpi}

# For each density, create appropriate sized icon
# Using the same base64 for simplicity - in production use properly sized icons

echo "$ICON_BASE64" | base64 -d > android/app/src/main/res/mipmap-mdpi/ic_launcher.png
echo "$ICON_BASE64" | base64 -d > android/app/src/main/res/mipmap-hdpi/ic_launcher.png
echo "$ICON_BASE64" | base64 -d > android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
echo "$ICON_BASE64" | base64 -d > android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
echo "$ICON_BASE64" | base64 -d > android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png

echo "✅ Fallback launcher icons created"
