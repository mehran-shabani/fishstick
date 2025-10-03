#!/bin/bash
# Script to generate basic launcher icons
# This creates simple colored square icons as placeholders

# Colors: Blue theme for blood sugar app
BG_COLOR="#2196F3"
TEXT_COLOR="#FFFFFF"

# Create icons using convert (ImageMagick) if available
if command -v convert &> /dev/null; then
    echo "Generating launcher icons..."
    
    # Define sizes for each density
    declare -A sizes
    sizes[mipmap-mdpi]=48
    sizes[mipmap-hdpi]=72
    sizes[mipmap-xhdpi]=96
    sizes[mipmap-xxhdpi]=144
    sizes[mipmap-xxxhdpi]=192
    
    for dir in "${!sizes[@]}"; do
        size=${sizes[$dir]}
        output_path="android/app/src/main/res/$dir/ic_launcher.png"
        
        # Create a simple colored square with rounded corners
        convert -size ${size}x${size} xc:"$BG_COLOR" \
                -fill "$TEXT_COLOR" \
                -font DejaVu-Sans-Bold \
                -pointsize $((size/3)) \
                -gravity center \
                -annotate +0+0 "BS" \
                -alpha set -virtual-pixel transparent \
                -channel A -blur 0x1 -level 50%,100% +channel \
                "$output_path"
        
        echo "Created $output_path"
    done
    
    echo "✅ Icon generation complete!"
else
    echo "⚠️  ImageMagick not found. Using fallback method..."
    echo "Please add launcher icons manually or use flutter_launcher_icons package"
fi
