#!/bin/bash

# ===================================================
# Livewire Setup Script
# ---------------------------------------------------
#
# Description:
#   This script sets up a fresh Livewire installation with all dependencies.
#   It handles Laravel setup, Composer, NPM, and generates the application key.
#   Uses ANSI colors for beautiful, easy-to-read output.
#
# Usage:
#   ./setup.sh
#
# Requirements:
#   - bash
#   - ansi (for colored output, see https://github.com/fidian/ansi)
#
# What this script does:
#   1. Checks system requirements (PHP, Composer, Node.js)
#   2. Installs Composer dependencies
#   3. Installs NPM dependencies
#   4. Sets up environment file
#   5. Generates application key
#   6. Runs database migrations
#   7. Builds frontend assets
#   8. Provides next steps
#
# =============================================

# Load the ANSI library
source ./scripts/ansi 2>/dev/null || {
    echo "⚠️  ANSI library not found. Installing basic color support..."
    # Fallback ANSI functions if ansi script is not available
    ansi::red() { printf '\033[31m'; }
    ansi::green() { printf '\033[32m'; }
    ansi::yellow() { printf '\033[33m'; }
    ansi::blue() { printf '\033[34m'; }
    ansi::magenta() { printf '\033[35m'; }
    ansi::cyan() { printf '\033[36m'; }
    ansi::white() { printf '\033[37m'; }
    ansi::bold() { printf '\033[1m'; }
    ansi::reset() { printf '\033[0m'; }
}

# ANSI color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
RESET='\033[0m'

# Nice divider
DIVIDER=$(printf "${BOLD}${BLUE}==========================================${RESET}")

# ASCII Art Banner
echo -e "${GREEN}"
cat << "EOF"
  █████████  ██████████ ███████████ █████  █████ ███████████ 
 ███░░░░░███░░███░░░░░█░█░░░███░░░█░░███  ░░███ ░░███░░░░░███
░███    ░░░  ░███  █ ░ ░   ░███  ░  ░███   ░███  ░███    ░███
░░█████████  ░██████       ░███     ░███   ░███  ░██████████ 
 ░░░░░░░░███ ░███░░█       ░███     ░███   ░███  ░███░░░░░░  
 ███    ░███ ░███ ░   █    ░███     ░███   ░███  ░███        
░░█████████  ██████████    █████    ░░████████   █████       
 ░░░░░░░░░  ░░░░░░░░░░    ░░░░░      ░░░░░░░░   ░░░░░        
EOF
echo -e "${RESET}Huement.com's Livewire Setup Script - v1.0${RESET}"
echo -e "${BLUE}Starting setup at $(date '+%I:%M %p, %B %d, %Y')...${RESET}"

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "info")
            echo -e "${BLUE}ℹ️  $message${RESET}"
            ;;
        "success")
            echo -e "${GREEN}✅ $message${RESET}"
            ;;
        "warning")
            echo -e "${YELLOW}⚠️  $message${RESET}"
            ;;
        "error")
            echo -e "${RED}❌ $message${RESET}"
            ;;
        "step")
            echo -e "${CYAN}🔧 $message${RESET}"
            ;;
        "progress")
            echo -e "${MAGENTA}⏳ $message${RESET}"
            ;;
    esac
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check PHP version
check_php_version() {
    if command_exists php; then
        local php_version=$(php -r "echo PHP_VERSION;")
        local major_version=$(echo $php_version | cut -d. -f1)
        local minor_version=$(echo $php_version | cut -d. -f2)
        
        if [ "$major_version" -ge 8 ] && [ "$minor_version" -ge 2 ]; then
            print_status "success" "PHP $php_version is installed and compatible"
            return 0
        else
            print_status "error" "PHP $php_version is installed but Laravel 11 requires PHP 8.2 or higher"
            return 1
        fi
    else
        print_status "error" "PHP is not installed"
        return 1
    fi
}

# Function to check Node.js version
check_node_version() {
    if command_exists node; then
        local node_version=$(node --version | sed 's/v//')
        local major_version=$(echo $node_version | cut -d. -f1)
        
        if [ "$major_version" -ge 16 ]; then
            print_status "success" "Node.js $node_version is installed and compatible"
            return 0
        else
            print_status "error" "Node.js $node_version is installed but requires Node.js 16 or higher"
            return 1
        fi
    else
        print_status "error" "Node.js is not installed"
        return 1
    fi
}

# Function to check Composer
check_composer() {
    if command_exists composer; then
        local composer_version=$(composer --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        print_status "success" "Composer $composer_version is installed"
        return 0
    else
        print_status "error" "Composer is not installed"
        return 1
    fi
}

# Function to check NPM
check_npm() {
    if command_exists npm; then
        local npm_version=$(npm --version)
        print_status "success" "NPM $npm_version is installed"
        return 0
    else
        print_status "error" "NPM is not installed"
        return 1
    fi
}

# Function to install Composer dependencies
install_composer_deps() {
    print_status "step" "Installing Composer dependencies..."
    
    # First, try to install from lock file
    if composer install --no-dev --optimize-autoloader 2>/dev/null; then
        print_status "success" "Composer dependencies installed successfully from lock file"
        return 0
    fi
    
    # If lock file is outdated, update dependencies
    print_status "warning" "Lock file is outdated, updating dependencies..."
    if composer update --no-dev --optimize-autoloader; then
        print_status "success" "Composer dependencies updated and installed successfully"
        return 0
    else
        print_status "error" "Failed to install Composer dependencies"
        return 1
    fi
}

# Function to install NPM dependencies
install_npm_deps() {
    print_status "step" "Installing NPM dependencies..."
    if npm install; then
        print_status "success" "NPM dependencies installed successfully"
        
        # Check for vulnerabilities and provide info
        if npm audit --audit-level=moderate 2>/dev/null | grep -q "found"; then
            print_status "warning" "NPM audit found some vulnerabilities. You can run 'npm audit fix' to address them."
        fi
        
        return 0
    else
        print_status "error" "Failed to install NPM dependencies"
        return 1
    fi
}

# Function to setup environment
setup_environment() {
    print_status "step" "Setting up environment configuration..."
    
    if [ ! -f .env ]; then
        if [ -f .env.example ]; then
            cp .env.example .env
            print_status "success" "Created .env file from .env.example"
        else
            print_status "warning" ".env.example not found, creating basic .env file"
            cat > .env << 'EOF'
APP_NAME="LivewireStarter"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_TIMEZONE=UTC
APP_URL=http://localhost:8008

APP_LOCALE=en
APP_FALLBACK_LOCALE=en
APP_FAKER_LOCALE=en_US

APP_MAINTENANCE_DRIVER=file
APP_MAINTENANCE_STORE=database

BCRYPT_ROUNDS=12

LOG_CHANNEL=stack
LOG_STACK=single
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=sqlite
DB_DATABASE=database/database.sqlite

SESSION_DRIVER=database
SESSION_LIFETIME=120
SESSION_ENCRYPT=false
SESSION_PATH=/
SESSION_DOMAIN=null

BROADCAST_CONNECTION=log
FILESYSTEM_DISK=local
QUEUE_CONNECTION=database

CACHE_STORE=database
CACHE_PREFIX=

MEMCACHED_HOST=127.0.0.1

REDIS_CLIENT=phpredis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=log
MAIL_HOST=127.0.0.1
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

VITE_APP_NAME="${APP_NAME}"
EOF
        fi
    else
        print_status "info" ".env file already exists"
    fi
    
    return 0
}

# Function to check if vendor directory exists
check_vendor_exists() {
    if [ ! -d "vendor" ] || [ ! -f "vendor/autoload.php" ]; then
        print_status "error" "Vendor directory or autoload.php not found. Composer dependencies must be installed first."
        return 1
    fi
    return 0
}

# Function to generate application key
generate_app_key() {
    print_status "step" "Generating application key..."
    
    if ! check_vendor_exists; then
        return 1
    fi
    
    if php artisan key:generate; then
        print_status "success" "Application key generated successfully"
        return 0
    else
        print_status "error" "Failed to generate application key"
        return 1
    fi
}

# Function to setup database
setup_database() {
    print_status "step" "Setting up database..."
    
    if ! check_vendor_exists; then
        return 1
    fi
    
    # Create database directory if it doesn't exist
    mkdir -p database
    
    # Create SQLite database file if it doesn't exist
    if [ ! -f database/database.sqlite ]; then
        touch database/database.sqlite
        print_status "success" "Created SQLite database file"
    else
        print_status "info" "SQLite database file already exists"
    fi
    
    # Run migrations (fresh to avoid conflicts with existing tables)
    print_status "progress" "Running database migrations..."
    if php artisan migrate:fresh --force; then
        print_status "success" "Database migrations completed successfully"
        return 0
    else
        print_status "error" "Failed to run database migrations"
        return 1
    fi
}

# Function to build frontend assets
build_assets() {
    print_status "step" "Building frontend assets..."
    if npm run build; then
        print_status "success" "Frontend assets built successfully"
        return 0
    else
        print_status "error" "Failed to build frontend assets"
        return 1
    fi
}

# Function to create storage links
create_storage_links() {
    print_status "step" "Creating storage links..."
    
    if ! check_vendor_exists; then
        print_status "warning" "Skipping storage links - vendor directory not found"
        return 0
    fi
    
    # Remove existing storage link or directory if it exists
    if [ -L "public/storage" ] || [ -d "public/storage" ]; then
        rm -rf public/storage
        print_status "info" "Removed existing storage link/directory"
    fi
    
    # Create storage link, suppress all output for "already exists" case
    if php artisan storage:link >/dev/null 2>&1; then
        print_status "success" "Storage links created successfully"
        return 0
    else
        # Check if the link was actually created despite the error message
        if [ -L "public/storage" ] || [ -d "public/storage" ]; then
            print_status "success" "Storage links already exist and are working"
            return 0
        else
            print_status "warning" "Failed to create storage links (this is usually not critical)"
            return 0
        fi
    fi
}

# Function to create missing directories
create_missing_directories() {
    print_status "step" "Creating missing directories..."
    
    # Create storage framework directories
    mkdir -p storage/framework/cache/data
    mkdir -p storage/framework/sessions
    mkdir -p storage/framework/views
    
    print_status "success" "Missing directories created successfully"
}

# Function to check if Docker is installed and running
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_status "error" "Docker is not installed"
        return 1
    fi
    
    if ! docker info &> /dev/null; then
        print_status "error" "Docker is not running"
        return 1
    fi
    
    print_status "success" "Docker is installed and running"
    return 0
}

# Function to check if Docker Compose is available
check_docker_compose() {
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_status "error" "Docker Compose is not available"
        return 1
    fi
    
    print_status "success" "Docker Compose is available"
    return 0
}

# Function to set permissions
set_permissions() {
    print_status "step" "Setting proper file permissions..."
    
    # Make sure storage and bootstrap/cache are writable
    chmod -R 775 storage bootstrap/cache 2>/dev/null || true
    
    # Make sure the database directory is writable
    chmod -R 775 database 2>/dev/null || true
    
    print_status "success" "File permissions set successfully"
    return 0
}

# Main setup function
main() {
    echo -e "${DIVIDER}"
    print_status "info" "Starting Livewire setup process..."
    echo -e "${DIVIDER}"
    
    # Ask user to choose between Sail and Direct PHP
    print_status "step" "Choose your development environment:"
    echo ""
    echo -e "${GREEN}${BOLD}Option 1: Laravel Sail (Recommended) 🚢${RESET}"
    echo -e "${GREEN}  • No local PHP, Composer, or Node.js required${RESET}"
    echo -e "${GREEN}  • Uses Docker containers${RESET}"
    echo -e "${GREEN}  • Consistent environment across all machines${RESET}"
    echo -e "${GREEN}  • Perfect for beginners and teams${RESET}"
    echo ""
    echo -e "${BLUE}${BOLD}Option 2: Direct PHP${RESET}"
    echo -e "${BLUE}  • Uses your local PHP installation${RESET}"
    echo -e "${BLUE}  • Faster startup times${RESET}"
    echo -e "${BLUE}  • Requires PHP 8.2+, Composer, Node.js${RESET}"
    echo -e "${BLUE}  • Best for experienced developers${RESET}"
    echo ""
    
    while true; do
        echo -e "${YELLOW}${BOLD}Which option would you like to use?${RESET}"
        echo -e "${YELLOW}1) Laravel Sail (Recommended)${RESET}"
        echo -e "${YELLOW}2) Direct PHP${RESET}"
        echo ""
        read -p "Enter your choice (1 or 2): " choice
        
        case $choice in
            1)
                USE_SAIL=true
                print_status "success" "You chose Laravel Sail! 🚢"
                break
                ;;
            2)
                USE_SAIL=false
                print_status "success" "You chose Direct PHP! ⚡"
                break
                ;;
            *)
                print_status "error" "Invalid choice. Please enter 1 or 2."
                echo ""
                ;;
        esac
    done
    
    echo ""
    
    if [ "$USE_SAIL" = true ]; then
        # Check Docker requirements for Sail
        print_status "step" "Checking Docker requirements for Laravel Sail..."
        echo ""
        
        local sail_requirements_met=true
        
        if ! check_docker; then
            sail_requirements_met=false
        fi
        
        if ! check_docker_compose; then
            sail_requirements_met=false
        fi
        
        echo ""
        
        if [ "$sail_requirements_met" = false ]; then
            print_status "error" "Docker requirements not met for Laravel Sail:"
            echo ""
            echo -e "${YELLOW}Required for Sail:${RESET}"
            echo -e "  • Docker Desktop or Docker Engine"
            echo -e "  • Docker Compose"
            echo ""
            echo -e "${BLUE}Installation guides:${RESET}"
            echo -e "  • Docker Desktop: https://www.docker.com/products/docker-desktop"
            echo -e "  • Docker Engine: https://docs.docker.com/engine/install/"
            echo ""
            echo -e "${CYAN}Alternative:${RESET} You can switch to Direct PHP by running this script again and choosing option 2."
            echo ""
            exit 1
        fi
        
        print_status "success" "Docker requirements are met for Laravel Sail!"
        echo ""
    else
        # Check system requirements for Direct PHP
        print_status "step" "Checking system requirements for Direct PHP..."
        echo ""
        
        local requirements_met=true
        
        if ! check_php_version; then
            requirements_met=false
        fi
        
        if ! check_composer; then
            requirements_met=false
        fi
        
        if ! check_node_version; then
            requirements_met=false
        fi
        
        if ! check_npm; then
            requirements_met=false
        fi
        
        echo ""
        
        if [ "$requirements_met" = false ]; then
            print_status "error" "System requirements not met for Direct PHP:"
            echo ""
            echo -e "${YELLOW}Required for Direct PHP:${RESET}"
            echo -e "  • PHP 8.2 or higher"
            echo -e "  • Composer"
            echo -e "  • Node.js 16 or higher"
            echo -e "  • NPM"
            echo ""
            echo -e "${BLUE}Installation guides:${RESET}"
            echo -e "  • PHP: https://www.php.net/manual/en/install.php"
            echo -e "  • Composer: https://getcomposer.org/download/"
            echo -e "  • Node.js: https://nodejs.org/en/download/"
            echo ""
            echo -e "${CYAN}Alternative:${RESET} You can switch to Laravel Sail by running this script again and choosing option 1."
            echo ""
            exit 1
        fi
        
        print_status "success" "All system requirements are met for Direct PHP!"
        echo ""
    fi
    
    # Setup steps
    local setup_steps=(
        "create_missing_directories"
        "install_composer_deps"
        "install_npm_deps"
        "setup_environment"
        "generate_app_key"
        "setup_database"
        "build_assets"
        "create_storage_links"
        "set_permissions"
    )
    
    local failed_steps=()
    
    for step in "${setup_steps[@]}"; do
        echo -e "${DIVIDER}"
        if ! $step; then
            failed_steps+=("$step")
        fi
        echo ""
    done
    
    # Final status
    echo -e "${DIVIDER}"
    if [ ${#failed_steps[@]} -eq 0 ]; then
        print_status "success" "Livewire setup completed successfully! 🎉"
        echo ""
        echo -e "${GREEN}${BOLD}Next Steps:${RESET}"
        
        if [ "$USE_SAIL" = true ]; then
            echo -e "${GREEN}1.${RESET} Start the development server with Laravel Sail:"
            echo -e "   ${CYAN}./run-sail.sh${RESET}"
            echo ""
            echo -e "${GREEN}2.${RESET} Start Vite for asset compilation:"
            echo -e "   ${CYAN}./vendor/bin/sail npm run dev${RESET}"
            echo ""
            echo -e "${GREEN}3.${RESET} Open your browser and visit:"
            echo -e "   ${CYAN}http://localhost${RESET}"
        else
            echo -e "${GREEN}1.${RESET} Start the development server with Direct PHP:"
            echo -e "   ${CYAN}./run.sh${RESET}"
            echo ""
            echo -e "${GREEN}2.${RESET} Start Vite for asset compilation:"
            echo -e "   ${CYAN}npm run dev${RESET}"
            echo ""
            echo -e "${GREEN}3.${RESET} Open your browser and visit:"
            echo -e "   ${CYAN}http://localhost:8080${RESET}"
        fi
        
        echo ""
        echo -e "${YELLOW}${BOLD}Alternative Options:${RESET}"
        if [ "$USE_SAIL" = true ]; then
            echo -e "${YELLOW}• Want to try Direct PHP instead?${RESET} Run this script again and choose option 2"
        else
            echo -e "${YELLOW}• Want to try Laravel Sail instead?${RESET} Run this script again and choose option 1"
        fi
        echo -e "${GREEN}4.${RESET} Default test user credentials:"
        echo -e "   ${CYAN}Email:${RESET} test@example.com"
        echo -e "   ${CYAN}Password:${RESET} password"
        echo ""
        echo -e "${GREEN}5.${RESET} Explore the Livewire components:"
        if [ "$USE_SAIL" = true ]; then
            echo -e "   ${CYAN}• Dashboard:${RESET} http://localhost/dashboard"
            echo -e "   ${CYAN}• Counter:${RESET} http://localhost/livewire/components/counter"
            echo -e "   ${CYAN}• Todo List:${RESET} http://localhost/livewire/components/todo"
            echo -e "   ${CYAN}• Contact Form:${RESET} http://localhost/livewire/components/form"
            echo -e "   ${CYAN}• Search Demo:${RESET} http://localhost/livewire/components/search"
            echo -e "   ${CYAN}• Maps:${RESET} http://localhost/livewire/components/maps-mapbox"
        else
            echo -e "   ${CYAN}• Dashboard:${RESET} http://localhost:8080/dashboard"
            echo -e "   ${CYAN}• Counter:${RESET} http://localhost:8080/livewire/components/counter"
            echo -e "   ${CYAN}• Todo List:${RESET} http://localhost:8080/livewire/components/todo"
            echo -e "   ${CYAN}• Contact Form:${RESET} http://localhost:8080/livewire/components/form"
            echo -e "   ${CYAN}• Search Demo:${RESET} http://localhost:8080/livewire/components/search"
            echo -e "   ${CYAN}• Maps:${RESET} http://localhost:8080/livewire/components/maps-mapbox"
        fi
        echo ""
        echo -e "${GREEN}6.${RESET} Check out the documentation:"
        echo -e "   ${CYAN}• Laravel:${RESET} https://laravel.com/docs"
        echo -e "   ${CYAN}• Livewire:${RESET} https://livewire.laravel.com/docs"
        echo -e "   ${CYAN}• Huement Blog:${RESET} https://huement.com/blog"
        echo ""
        echo -e "${BLUE}${BOLD}Happy coding! 🚀${RESET}"
    else
        print_status "error" "Setup completed with ${#failed_steps[@]} error(s)"
        echo ""
        echo -e "${RED}Failed steps:${RESET}"
        for step in "${failed_steps[@]}"; do
            echo -e "  • $step"
        done
        echo ""
        
        # Check if Composer dependencies failed
        if [[ " ${failed_steps[@]} " =~ " install_composer_deps " ]]; then
            echo -e "${YELLOW}${BOLD}Composer Dependencies Issue:${RESET}"
            echo -e "${YELLOW}The main issue is that Composer dependencies failed to install.${RESET}"
            echo -e "${YELLOW}This is usually due to an outdated composer.lock file.${RESET}"
            echo ""
            echo -e "${CYAN}Try running these commands manually:${RESET}"
            echo -e "  ${CYAN}composer update${RESET}"
            echo -e "  ${CYAN}php artisan key:generate${RESET}"
            echo -e "  ${CYAN}php artisan migrate${RESET}"
            echo ""
        fi
        
        echo -e "${YELLOW}You may need to run the failed steps manually or check the error messages above.${RESET}"
        exit 1
    fi
    
    echo -e "${DIVIDER}"
}

# Run the main function
main "$@"
