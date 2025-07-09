#!/bin/bash

# Script to create code-themed favicon and icons
# This script uses ImageMagick to create simple code-themed icons

echo "Creating code-themed web icons..."

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick not found. Please install ImageMagick to generate custom icons."
    echo "On macOS: brew install imagemagick"
    echo "On Ubuntu: sudo apt install imagemagick"
    echo ""
    echo "For now, we'll update the web configuration to use existing icons with code theme colors."
fi

# Create a simple SVG code icon
cat > web/icons/code-icon.svg << 'EOF'
<svg width="512" height="512" viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="512" height="512" fill="#1A1A1A"/>
  
  <!-- Code brackets and slash -->
  <g stroke="#64FFDA" stroke-width="32" fill="none" stroke-linecap="round" stroke-linejoin="round">
    <!-- Left bracket < -->
    <path d="M160 128L64 256L160 384"/>
    <!-- Right bracket > -->
    <path d="M352 128L448 256L352 384"/>
    <!-- Slash / -->
    <path d="M288 128L224 384"/>
  </g>
</svg>
EOF

echo "Created SVG icon: web/icons/code-icon.svg"

# If ImageMagick is available, convert SVG to PNG
if command -v convert &> /dev/null; then
    echo "Converting SVG to PNG formats..."
    
    # Generate favicon
    convert web/icons/code-icon.svg -resize 32x32 web/favicon.png
    echo "Generated: web/favicon.png"
    
    # Generate app icons
    convert web/icons/code-icon.svg -resize 192x192 web/icons/Icon-192.png
    convert web/icons/code-icon.svg -resize 512x512 web/icons/Icon-512.png
    echo "Generated: web/icons/Icon-192.png"
    echo "Generated: web/icons/Icon-512.png"
    
    # Generate maskable icons with padding
    convert web/icons/code-icon.svg -resize 154x154 -background "#1A1A1A" -gravity center -extent 192x192 web/icons/Icon-maskable-192.png
    convert web/icons/code-icon.svg -resize 410x410 -background "#1A1A1A" -gravity center -extent 512x512 web/icons/Icon-maskable-512.png
    echo "Generated: web/icons/Icon-maskable-192.png"
    echo "Generated: web/icons/Icon-maskable-512.png"
    
    echo "All icons generated successfully!"
else
    echo "ImageMagick not available. Using manual web configuration updates."
fi

echo "Code-themed web icons setup complete!"
