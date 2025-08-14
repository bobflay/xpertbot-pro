#!/bin/bash
# setup/flutter-dependencies.sh

echo "📱 Installing Flutter dependencies..."

# Detect if we're in Codespaces or local environment
if [ -d "/workspaces" ]; then
    # Codespace environment
    WORKSPACE_DIR="/workspaces/$(ls /workspaces | head -1)"
    cd "$WORKSPACE_DIR"
else
    # Local environment - use current directory or parent
    if [ -f "setup/flutter-dependencies.sh" ]; then
        # We're in the project root
        WORKSPACE_DIR="$(pwd)"
    else
        # We might be in a subdirectory
        cd ..
        WORKSPACE_DIR="$(pwd)"
    fi
fi

# Add Flutter to PATH
export PATH="$PATH:/usr/local/flutter/bin"

# Check if Flutter project exists
if [ ! -d "flutter-app" ]; then
    echo "Flutter app directory not found. Something went wrong with the template."
    exit 1
fi

cd flutter-app

# Get Flutter dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Enable web support (in case it's not enabled)
flutter config --enable-web

echo "✅ Flutter dependencies installed successfully!"
echo "📍 Flutter Web available at: http://localhost:3000"
echo "💡 Run 'flutter run -d web-server --web-hostname=0.0.0.0 --web-port=3000' to start"