# Web Icons Setup

This project uses a custom code-themed icon design that reflects the developer/engineering identity.

## Icon Design

The icon features:
- **Background**: Dark theme (#1A1A1A) 
- **Accent**: Cyan (#64FFDA) - matches the app's accent color
- **Symbol**: Code brackets `< >` with a forward slash `/` representing programming

## Files Structure

```
web/
├── favicon.svg          # SVG favicon (32x32, scalable)
├── favicon.png          # PNG fallback favicon
├── browserconfig.xml    # Windows tile configuration
├── manifest.json        # Web app manifest
└── icons/
    ├── Icon-192.png     # Standard app icon (192x192)
    ├── Icon-512.png     # Large app icon (512x512)
    ├── Icon-maskable-192.png  # Maskable icon (192x192)
    ├── Icon-maskable-512.png  # Maskable icon (512x512)
    └── code-icon.svg    # Source SVG template
```

## Features

- **SVG Favicon**: Modern, scalable favicon that works on all browsers
- **Progressive Web App**: Full PWA manifest with proper icons
- **Social Media**: Open Graph and Twitter meta tags for sharing
- **Cross-Platform**: iOS, Android, and Windows tile support
- **Theme Colors**: Consistent with app's dark theme and accent colors

## Customization

To update the icon:

1. **Edit the SVG**: Modify `web/favicon.svg` or `web/icons/code-icon.svg`
2. **Generate PNGs**: Run `./create_code_icons.sh` (requires ImageMagick)
3. **Update Colors**: Modify theme colors in `web/manifest.json`

## Installation Requirements

For generating PNG icons from SVG:

```bash
# macOS
brew install imagemagick

# Ubuntu/Debian
sudo apt install imagemagick

# Then run
./create_code_icons.sh
```

## Browser Support

- ✅ **Modern Browsers**: SVG favicon
- ✅ **Legacy Browsers**: PNG fallback
- ✅ **Mobile**: Apple touch icons, Android app icons
- ✅ **PWA**: Maskable icons for adaptive shapes
- ✅ **Windows**: Tile configuration

The icon system provides a consistent brand experience across all platforms and devices.
