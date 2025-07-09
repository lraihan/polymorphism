#!/bin/bash

# Load environment variables from .env.local
if [ -f ".env.local" ]; then
    export $(cat .env.local | grep -v '^#' | xargs)
    echo "Loaded environment variables from .env.local"
else
    echo "Warning: .env.local file not found. Please copy .env.example to .env.local and configure your EmailJS credentials."
fi

# Run Flutter with environment variables
echo "Starting Flutter app with environment variables..."
flutter run -d chrome \
    --dart-define=EMAILJS_SERVICE_ID="$EMAILJS_SERVICE_ID" \
    --dart-define=EMAILJS_TEMPLATE_ID="$EMAILJS_TEMPLATE_ID" \
    --dart-define=EMAILJS_PUBLIC_KEY="$EMAILJS_PUBLIC_KEY"
