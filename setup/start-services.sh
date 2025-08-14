#!/bin/bash
# setup/start-services.sh

echo "Starting development services..."

# Start Laravel development server
cd /workspaces/xpertbot-pro-template/laravel-api
php artisan serve --host=0.0.0.0 --port=8000 &

# Start Flutter web server
cd /workspaces/xpertbot-pro-template/flutter-app
flutter run -d web-server --web-hostname=0.0.0.0 --web-port=3000 &

echo "Services started!"
echo "Laravel API: http://localhost:8000"
echo "Flutter Web: http://localhost:3000"