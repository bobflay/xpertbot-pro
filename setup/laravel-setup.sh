#!/bin/bash
# setup/laravel-setup.sh

echo "Setting up Laravel with Nova..."

# Create Laravel project
composer create-project laravel/laravel laravel-api
cd laravel-api

# Install Laravel Nova (requires license)
# Note: You'll need to add Nova credentials to composer.json
composer require laravel/nova

# Install additional packages
composer require \
    laravel/sanctum \
    laravel/tinker \
    spatie/laravel-permission \
    spatie/laravel-query-builder

# Setup environment
cp .env.example .env
php artisan key:generate

# Configure SQLite database
sed -i 's/DB_CONNECTION=mysql/DB_CONNECTION=sqlite/' .env
sed -i 's/DB_DATABASE=laravel/DB_DATABASE=\/workspaces\/xpertbot-pro-template\/laravel-api\/database\/database.sqlite/' .env
touch database/database.sqlite

# Run migrations
php artisan migrate

# Install Nova
php artisan nova:install
php artisan migrate

# Create sample models and resources
php artisan make:model Product -m
php artisan make:nova-resource Product

# Seed sample data
php artisan make:seeder ProductSeeder
php artisan db:seed

echo "Laravel with Nova setup complete!"