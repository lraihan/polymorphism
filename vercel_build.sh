#!/usr/bin/env bash
# Vercel production build: fetch a pinned Flutter SDK and build the web app,
# injecting the EmailJS config (compile-time String.fromEnvironment) from Vercel
# environment variables. Unset vars default to empty so the build never fails.
set -euo pipefail

git clone https://github.com/flutter/flutter.git --depth 1 -b 3.44.2 _flutter
export PATH="$PWD/_flutter/bin:$PATH"

flutter --version
flutter config --enable-web

# Icon fonts are tree-shaken (every icon is a static const), so the full
# MaterialIcons/Lucide fonts collapse to a tiny subset — do NOT pass
# --no-tree-shake-icons.
flutter build web --release \
  --dart-define=EMAILJS_SERVICE_ID="${EMAILJS_SERVICE_ID:-}" \
  --dart-define=EMAILJS_TEMPLATE_ID="${EMAILJS_TEMPLATE_ID:-}" \
  --dart-define=EMAILJS_PUBLIC_KEY="${EMAILJS_PUBLIC_KEY:-}"

# ── Post-build slimming — none of this changes what the browser downloads ─────
# CanvasKit loads from gstatic's CDN (useLocalCanvasKit is false, engineRevision
# is pinned), so the local canvaskit/ payload is never fetched at runtime.
# Strip the debug symbol maps and the unused renderer variants; keep the default
# canvaskit.js/.wasm as a harmless fallback.
find build/web -name '*.js.symbols' -delete
rm -rf build/web/canvaskit/chromium build/web/canvaskit/experimental_webparagraph
rm -f build/web/canvaskit/skwasm* build/web/canvaskit/wimp*
