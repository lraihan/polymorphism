#!/bin/bash

# Production build script for Flutter Web with environment variables

# Check if production environment file exists
if [ -f ".env.production" ]; then
    export $(cat .env.production | grep -v '^#' | xargs)
    echo "Loaded production environment variables from .env.production"
else
    echo "Warning: .env.production file not found. Using environment variables from system or CI/CD."
fi

# Validate required environment variables
if [ -z "$EMAILJS_SERVICE_ID" ] || [ -z "$EMAILJS_TEMPLATE_ID" ] || [ -z "$EMAILJS_PUBLIC_KEY" ]; then
    echo "Error: Missing required environment variables:"
    echo "  EMAILJS_SERVICE_ID: ${EMAILJS_SERVICE_ID:-(not set)}"
    echo "  EMAILJS_TEMPLATE_ID: ${EMAILJS_TEMPLATE_ID:-(not set)}"
    echo "  EMAILJS_PUBLIC_KEY: ${EMAILJS_PUBLIC_KEY:-(not set)}"
    echo ""
    echo "Please set these environment variables or create a .env.production file."
    exit 1
fi

echo "Building Flutter web app for production..."
flutter build web --release \
    --dart-define=EMAILJS_SERVICE_ID="$EMAILJS_SERVICE_ID" \
    --dart-define=EMAILJS_TEMPLATE_ID="$EMAILJS_TEMPLATE_ID" \
    --dart-define=EMAILJS_PUBLIC_KEY="$EMAILJS_PUBLIC_KEY"

echo "Production build completed successfully!"
echo "Build output available in: build/web/"
