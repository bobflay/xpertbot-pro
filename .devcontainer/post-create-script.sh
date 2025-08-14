#!/bin/bash
# .devcontainer/post-create-script.sh

set -e

echo "🚀 Setting up XpertBot Pro Environment..."

# Update system
sudo apt-get update && sudo apt-get upgrade -y

# Install system dependencies
sudo apt-get install -y \
    curl \
    wget \
    unzip \
    git \
    sqlite3 \
    libsqlite3-dev \
    build-essential

# Install Composer
echo "📦 Installing Composer..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

# Install Flutter
echo "🦋 Installing Flutter..."
cd /tmp
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
sudo tar xf flutter_linux_3.16.0-stable.tar.xz -C /usr/local/
sudo chown -R vscode:vscode /usr/local/flutter
echo 'export PATH="$PATH:/usr/local/flutter/bin"' >> ~/.bashrc

# Add Flutter to current session
export PATH="$PATH:/usr/local/flutter/bin"

# Install Laravel Installer
echo "🎵 Installing Laravel..."
composer global require laravel/installer
echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc

# Node.js 20 comes with compatible npm version

# Setup Laravel Project
echo "🏗️ Creating Laravel Project with Nova..."
bash setup/laravel-setup.sh

# Setup Flutter Project
echo "📱 Creating Flutter Project..."
bash setup/flutter-setup.sh

# Install Claude CLI (if available)
echo "🤖 Setting up Claude integration..."
bash setup/claude-setup.sh

# Set permissions
sudo chown -R vscode:vscode /workspaces

echo "✅ XpertBot Pro Environment Ready!"
echo "🌐 Laravel API will be available at: http://localhost:8000"
echo "📱 Flutter Web will be available at: http://localhost:3000"