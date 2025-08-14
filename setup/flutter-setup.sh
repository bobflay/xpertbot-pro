#!/bin/bash
# setup/flutter-setup.sh

echo "Setting up Flutter project..."

# Detect if we're in Codespaces or local environment
if [ -d "/workspaces" ]; then
    # Codespace environment
    WORKSPACE_DIR="/workspaces/$(ls /workspaces | head -1)"
    cd "$WORKSPACE_DIR"
else
    # Local environment - use current directory or parent
    if [ -f "setup/flutter-setup.sh" ]; then
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

# Check if Flutter project already exists
if [ -d "flutter-app" ]; then
    echo "Flutter app directory already exists. Skipping creation."
    exit 0
fi

# Create Flutter project
flutter create flutter-app
cd flutter-app

# Add dependencies to pubspec.yaml
cat >> pubspec.yaml << EOL

dependencies:
  dio: ^5.3.2
  shared_preferences: ^2.2.2
  provider: ^6.1.1
  go_router: ^12.1.1
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.7
  json_serializable: ^6.7.1
EOL

# Get dependencies
flutter pub get

# Create basic folder structure
mkdir -p lib/{models,services,screens,widgets}

# Create sample files
cat > lib/services/api_service.dart << 'EOL'
import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers['Accept'] = 'application/json';
  }

  Future<Response> get(String path) async {
    return await _dio.get(path);
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    return await _dio.post(path, data: data);
  }
}
EOL

# Enable web support
flutter config --enable-web

echo "Flutter project setup complete!"