# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

XpertBot Pro is a comprehensive learning platform template designed for managers and C-level executives to understand modern web and mobile development technologies. This is a **GitHub Codespaces template** that auto-generates a Laravel backend API with Nova admin panel and a Flutter mobile application when launched.

## Repository Structure

The template includes automated setup scripts and configuration:

```
xpertbot-pro-template/
├── .devcontainer/
│   ├── devcontainer.json           # Codespace configuration
│   ├── Dockerfile (optional)       # Custom container setup
│   └── post-create-script.sh      # Auto-setup script
├── laravel-api/                    # Laravel backend (created by setup)
│   ├── app/Http/Controllers/API/   # RESTful API endpoints
│   ├── app/Models/                 # Eloquent database models
│   ├── app/Nova/                   # Nova admin resources
│   ├── routes/api.php             # API route definitions
│   ├── database/database.sqlite   # SQLite database
│   └── composer.json              # PHP dependencies
├── flutter-app/                   # Flutter mobile app (created by setup)
│   ├── lib/models/                # Dart data models
│   ├── lib/services/              # API service layer (Dio client)
│   ├── lib/screens/               # UI screens
│   ├── lib/widgets/               # Reusable UI components
│   ├── pubspec.yaml              # Flutter dependencies
│   └── web/                      # Web build output
├── setup/                        # Setup automation scripts
│   ├── laravel-setup.sh          # Laravel + Nova installation
│   ├── flutter-setup.sh          # Flutter project creation
│   ├── claude-setup.sh           # Claude integration setup
│   └── start-services.sh         # Service startup script
└── README.md                     # Main documentation
```

## Automated Setup Process

### DevContainer Configuration
The `.devcontainer/devcontainer.json` provides:
- **PHP 8.2** runtime environment
- **Node.js 18** for build tools
- **Docker-in-Docker** for containerization
- **VS Code Extensions**: PHP IntelliSense, Flutter/Dart, Tailwind CSS
- **Port Forwarding**: 8000 (Laravel), 3000 (Flutter), 5173, 8080

### Post-Create Script Actions
The `post-create-script.sh` automatically:
1. Updates system packages
2. Installs Composer (PHP dependency manager)
3. Downloads and configures Flutter SDK
4. Installs Laravel installer globally
5. Executes Laravel setup script
6. Executes Flutter setup script
7. Sets proper file permissions

### Laravel Setup Details
The `laravel-setup.sh` script:
- Creates Laravel project with `composer create-project`
- Installs **Laravel Nova** admin panel
- Adds essential packages: Sanctum (auth), Spatie permissions
- Configures **SQLite database** for development
- Creates sample models (Product) with Nova resources
- Seeds database with sample data

### Flutter Setup Details
The `flutter-setup.sh` script:
- Creates Flutter project with web support enabled
- Adds essential dependencies: **Dio** (HTTP), **Provider** (state), **GoRouter** (navigation)
- Creates folder structure for models, services, screens, widgets
- Generates sample API service class with Laravel integration

## Development Commands

### Service Management
```bash
# Start all services (Laravel API + Flutter Web)
bash setup/start-services.sh

# Services will be available at:
# Laravel API: http://localhost:8000
# Nova Admin: http://localhost:8000/nova  
# Flutter Web: http://localhost:3000
```

### Laravel API Commands
```bash
# Navigate to Laravel directory
cd laravel-api

# Install dependencies
composer install

# Database operations
php artisan migrate          # Run migrations
php artisan migrate --seed   # Run migrations with sample data
php artisan db:seed         # Seed database only

# Development server
php artisan serve --host=0.0.0.0 --port=8000

# Laravel Nova
php artisan nova:install    # Install Nova (after adding license)
php artisan nova:user      # Create Nova admin user

# API and development
php artisan route:list --path=api    # List API endpoints
php artisan tinker                   # Interactive PHP console
php artisan test                     # Run tests
php artisan make:model Product -m    # Create model with migration
php artisan make:nova-resource Product  # Create Nova resource

# Cache and optimization
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### Flutter App Commands  
```bash
# Navigate to Flutter directory
cd flutter-app

# Dependencies
flutter pub get              # Install dependencies
flutter pub upgrade          # Upgrade dependencies

# Development
flutter run -d web-server --web-hostname=0.0.0.0 --web-port=3000
flutter run -d chrome        # Run in Chrome browser
flutter config --enable-web # Enable web support

# Building
flutter build web           # Build for web deployment
flutter build web --release # Production build

# Code quality
flutter analyze            # Static analysis
flutter test              # Run unit tests
flutter doctor            # Check Flutter installation

# Code generation (for JSON serialization)
flutter packages pub run build_runner build
```

### Development Workflow Commands
```bash
# Check service status
ps aux | grep -E "(artisan|flutter)"

# Stop services
pkill -f "artisan serve"
pkill -f "flutter run"

# View logs
tail -f laravel-api/storage/logs/laravel.log

# Database inspection
sqlite3 laravel-api/database/database.sqlite
# SQLite commands: .tables, .schema tablename, SELECT * FROM products;
```

## Architecture Overview

### Backend (Laravel + Nova)
- **Laravel API**: RESTful endpoints for mobile app communication
- **Nova Admin Panel**: Administrative interface for data management
- **Database**: SQLite for development (Users, Products, Orders models)
- **Authentication**: Laravel Sanctum for API authentication
- **CORS**: Configured for cross-origin requests from Flutter app

### Frontend (Flutter)
- **Cross-platform**: Web, iOS, and Android from single codebase
- **State Management**: Provider pattern or similar
- **HTTP Client**: Dio for API communication
- **Local Storage**: Shared Preferences for app settings
- **Navigation**: Named routes with parameters
- **Architecture**: MVC pattern for code organization

### Port Configuration and Service Access

**Development Ports:**
- **8000**: Laravel API and Nova Admin Panel
- **3000**: Flutter Web Application  
- **5173**: Additional frontend development server
- **8080**: Alternative HTTP service

**Service URLs in Codespace:**
```bash
# Laravel API endpoints
https://[codespace-name]-8000.app.github.dev/api/*

# Nova Admin Panel
https://[codespace-name]-8000.app.github.dev/nova

# Flutter Web App
https://[codespace-name]-3000.app.github.dev
```

### Communication Flow
```
Flutter App (Port 3000) -> HTTP Requests -> Laravel API (Port 8000) -> SQLite DB
                        <- JSON Response   <-                        <-

Nova Admin (Port 8000/nova) -> Direct DB Access -> SQLite DB
```

### Service Dependencies and Startup
The `start-services.sh` script manages concurrent service startup:
1. **Laravel Server**: `php artisan serve --host=0.0.0.0 --port=8000 &`
2. **Flutter Web**: `flutter run -d web-server --web-hostname=0.0.0.0 --web-port=3000 &`

Both services run in background processes, accessible via forwarded ports.

## Key Integration Points

1. **API Endpoints**: Flutter app consumes Laravel API at `/api/*` routes
2. **Authentication**: Laravel Sanctum for token-based API authentication
3. **Data Flow**: Nova admin manages data, Flutter app displays via API calls
4. **CORS Configuration**: Laravel configured to accept requests from Flutter origin
5. **Environment URLs**: GitHub Codespaces auto-generates public URLs for both services
6. **Database**: Shared SQLite database accessible by both Laravel API and Nova admin

## Educational Focus

This template is designed for executive learning, emphasizing:
- **Business Value**: Understanding development concepts from leadership perspective
- **Team Communication**: How to effectively work with technical teams
- **Technology Decisions**: Making informed choices about development stack
- **Project Management**: Understanding development timelines and resources

## Development Workflow

### Initial Setup (Automated)
1. **Create Repository**: Use GitHub template to create new repository
2. **Launch Codespace**: GitHub automatically runs `post-create-script.sh`
3. **Auto-Installation**: Script installs PHP, Composer, Flutter, Node.js
4. **Project Creation**: Laravel and Flutter projects are generated
5. **Service Startup**: `start-services.sh` launches both applications

### Daily Development Tasks
1. **Check Service Status**: `ps aux | grep -E "(artisan|flutter)"`
2. **Access Applications**: Use Codespace-provided URLs
3. **Database Management**: Use Nova admin at `/nova` endpoint
4. **API Testing**: Use browser or curl to test `/api/*` endpoints  
5. **Code Changes**: Edit files, services auto-reload
6. **Debugging**: Check logs in `laravel-api/storage/logs/`

### Troubleshooting Common Issues
```bash
# Services not running
bash setup/start-services.sh

# Laravel database issues
cd laravel-api && php artisan migrate:fresh --seed

# Flutter build issues  
cd flutter-app && flutter clean && flutter pub get

# Port conflicts
pkill -f "artisan serve" && pkill -f "flutter run"
bash setup/start-services.sh
```

## Claude AI Integration

- **Configuration**: Uses `.claude/settings.local.json` for permissions
- **Development Support**: AI assistance integrated into VS Code environment
- **Learning Context**: Claude understands both Laravel and Flutter patterns
- **Code Explanation**: Can explain executive-focused business concepts

## Key Files for Development

### Laravel Essential Files
- `laravel-api/routes/api.php`: API endpoint definitions
- `laravel-api/app/Models/`: Database model classes  
- `laravel-api/app/Nova/`: Admin panel resource classes
- `laravel-api/database/migrations/`: Database schema changes
- `laravel-api/.env`: Environment configuration

### Flutter Essential Files  
- `flutter-app/lib/services/api_service.dart`: HTTP client for Laravel API
- `flutter-app/lib/models/`: Data model classes (matching Laravel models)
- `flutter-app/lib/screens/`: UI screens (Login, Dashboard, Product List)
- `flutter-app/pubspec.yaml`: Dependencies and project configuration
- `flutter-app/web/index.html`: Web app entry point

### Development Configuration
- `.devcontainer/devcontainer.json`: Codespace environment setup
- `setup/*.sh`: Installation and startup automation scripts