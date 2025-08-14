#!/bin/bash
# setup/laravel-dependencies.sh

echo "🚀 Installing Laravel dependencies..."

# Detect if we're in Codespaces or local environment
if [ -d "/workspaces" ]; then
    # Codespace environment
    WORKSPACE_DIR="/workspaces/$(ls /workspaces | head -1)"
    cd "$WORKSPACE_DIR"
else
    # Local environment - use current directory or parent
    if [ -f "setup/laravel-dependencies.sh" ]; then
        # We're in the project root
        WORKSPACE_DIR="$(pwd)"
    else
        # We might be in a subdirectory
        cd ..
        WORKSPACE_DIR="$(pwd)"
    fi
fi

# Check if Laravel project exists
if [ ! -d "laravel-api" ]; then
    echo "Laravel API directory not found. Something went wrong with the template."
    exit 1
fi

cd laravel-api

# Install Composer dependencies
echo "📦 Installing Composer dependencies..."
composer install --no-interaction

# Setup environment if .env doesn't exist
if [ ! -f ".env" ]; then
    cp .env.example .env
    php artisan key:generate
fi

# Configure SQLite database path for current environment
if [ -d "/workspaces" ]; then
    # Codespace environment
    DB_PATH="/workspaces/$(ls /workspaces | head -1)/laravel-api/database/database.sqlite"
else
    # Local environment
    DB_PATH="$WORKSPACE_DIR/laravel-api/database/database.sqlite"
fi

sed -i "s|DB_DATABASE=.*|DB_DATABASE=$DB_PATH|" .env

# Create database file if it doesn't exist
touch database/database.sqlite

# Run migrations and seed data
php artisan migrate:fresh --seed

# Configure CORS for API access
php artisan config:clear

echo "✅ Laravel dependencies installed successfully!"
echo "📍 API available at: http://localhost:8000/api"
echo "📚 Sample endpoints:"
echo "   GET    /api/products"
echo "   POST   /api/products"
echo "   GET    /api/products/{id}"
echo "   PUT    /api/products/{id}"
echo "   DELETE /api/products/{id}"