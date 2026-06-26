#!/usr/bin/env bash
# Vercel production build: fetch a pinned Flutter SDK and build the web app,
# injecting the EmailJS config (compile-time String.fromEnvironment) from Vercel
# environment variables. Unset vars default to empty so the build never fails.
set -euo pipefail

git clone https://github.com/flutter/flutter.git --depth 1 -b 3.44.2 _flutter
export PATH="$PWD/_flutter/bin:$PATH"

flutter --version
flutter config --enable-web

flutter build web --release --no-tree-shake-icons \
  --dart-define=EMAILJS_SERVICE_ID="${EMAILJS_SERVICE_ID:-}" \
  --dart-define=EMAILJS_TEMPLATE_ID="${EMAILJS_TEMPLATE_ID:-}" \
  --dart-define=EMAILJS_PUBLIC_KEY="${EMAILJS_PUBLIC_KEY:-}"
