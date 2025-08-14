#!/bin/bash
# setup/start-services.sh

echo "Starting development services..."

# Detect workspace directory dynamically
WORKSPACE_DIR="/workspaces/$(ls /workspaces | head -1)"
cd "$WORKSPACE_DIR"

# Add Flutter to PATH if not already added
export PATH="$PATH:/usr/local/flutter/bin"

# Check if Laravel project exists and start it
if [ -d "laravel-api" ]; then
    echo "Starting Laravel API server..."
    cd laravel-api
    php artisan serve --host=0.0.0.0 --port=8000 &
    cd ..
else
    echo "Laravel API not found. Run setup/laravel-setup.sh first."
fi

# Check if Flutter project exists and start it
if [ -d "flutter-app" ]; then
    echo "Starting Flutter web server..."
    cd flutter-app
    flutter run -d web-server --web-hostname=0.0.0.0 --web-port=3000 &
    cd ..
else
    echo "Flutter app not found. Run setup/flutter-setup.sh first."
fi

echo "Services startup initiated!"
echo "Laravel API: http://localhost:8000"
echo "Flutter Web: http://localhost:3000"
echo ""
echo "Note: Services may take a few moments to fully start."
echo "Check the ports tab in VS Code to see when they're ready."