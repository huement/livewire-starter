#!/usr/bin/env bash

# Simple color functions that work in most terminals
red() { printf '\033[31m'; }
green() { printf '\033[32m'; }
yellow() { printf '\033[33m'; }
blue() { printf '\033[34m'; }
bold() { printf '\033[1m'; }
reset() { printf '\033[0m'; }

# Color variables
RED=$(red)
GREEN=$(green)
YELLOW=$(yellow)
BLUE=$(blue)
BOLD=$(bold)
RESET=$(reset)

# Divider for visual separation
DIVIDER="=========================================="

# Print status function
print_status() {
    local type=$1
    local message=$2
    
    case $type in
        "info")
            echo -e "${BLUE}[INFO]${RESET} ${message}"
            ;;
        "success")
            echo -e "${GREEN}[OK]${RESET} ${message}"
            ;;
        "warning")
            echo -e "${YELLOW}[WARN]${RESET} ${message}"
            ;;
        "error")
            echo -e "${RED}[ERROR]${RESET} ${message}"
            ;;
        "step")
            echo -e "${BLUE}[STEP]${RESET} ${message}"
            ;;
    esac
}

# Check if PHP is installed and version is compatible
check_php() {
    if ! command -v php &> /dev/null; then
        print_status "error" "PHP is not installed or not in PATH"
        echo ""
        echo -e "${YELLOW}${BOLD}Solution Options:${RESET}"
        echo -e "${YELLOW}1.${RESET} Install PHP 8.2+ on your system"
        echo -e "${YELLOW}2.${RESET} Use Laravel Sail instead: ${BLUE}./run-sail.sh${RESET}"
        echo ""
        echo -e "${BLUE}${BOLD}Installation guides:${RESET}"
        echo -e "${BLUE}• macOS:${RESET} brew install php"
        echo -e "${BLUE}• Ubuntu/Debian:${RESET} sudo apt install php8.2-cli"
        echo -e "${BLUE}• Windows:${RESET} https://windows.php.net/download/"
        echo ""
        return 1
    fi
    
    local php_version=$(php -r "echo PHP_VERSION;" 2>/dev/null)
    local major_version=$(echo $php_version | cut -d. -f1)
    local minor_version=$(echo $php_version | cut -d. -f2)
    
    if [ "$major_version" -lt 8 ] || ([ "$major_version" -eq 8 ] && [ "$minor_version" -lt 2 ]); then
        print_status "error" "PHP version $php_version is not compatible (requires PHP 8.2+)"
        echo ""
        echo -e "${YELLOW}${BOLD}Solution Options:${RESET}"
        echo -e "${YELLOW}1.${RESET} Upgrade to PHP 8.2+ on your system"
        echo -e "${YELLOW}2.${RESET} Use Laravel Sail instead: ${BLUE}./run-sail.sh${RESET}"
        echo ""
        return 1
    fi
    
    print_status "success" "PHP $php_version is installed and compatible"
    return 0
}

# Check if Composer dependencies are installed
check_composer_deps() {
    if [ ! -d "vendor" ] || [ ! -f "vendor/autoload.php" ]; then
        print_status "error" "Composer dependencies not installed"
        echo ""
        echo -e "${YELLOW}${BOLD}Solution:${RESET}"
        echo -e "${YELLOW}Run the setup script first:${RESET} ${BLUE}./setup.sh${RESET}"
        echo ""
        return 1
    fi
    
    print_status "success" "Composer dependencies are installed"
    return 0
}

# Check if .env file exists
check_env_file() {
    if [ ! -f ".env" ]; then
        print_status "error" ".env file not found"
        echo ""
        echo -e "${YELLOW}${BOLD}Solution:${RESET}"
        echo -e "${YELLOW}Run the setup script first:${RESET} ${BLUE}./setup.sh${RESET}"
        echo ""
        return 1
    fi
    
    print_status "success" ".env file exists"
    return 0
}

# Check if application key is set
check_app_key() {
    if ! grep -q "APP_KEY=" .env || grep -q "APP_KEY=$" .env; then
        print_status "error" "Application key not set"
        echo ""
        echo -e "${YELLOW}${BOLD}Solution:${RESET}"
        echo -e "${YELLOW}Run the setup script first:${RESET} ${BLUE}./setup.sh${RESET}"
        echo ""
        return 1
    fi
    
    print_status "success" "Application key is set"
    return 0
}

# Main function
main() {
    echo -e "${GREEN}${BOLD}"
    echo "=========================================="
echo -e "${GREEN}"
    cat << "EOF"
░█░░░▀█▀░█░█░█▀▀░█░█░▀█▀░█▀▄░█▀▀
░█░░░░█░░▀▄▀░█▀▀░█▄█░░█░░█▀▄░█▀▀
░▀▀▀░▀▀▀░░▀░░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀      
EOF
    echo "  Livewire Run Script v1.0"
    echo "=========================================="
    echo -e "${RESET}"
    echo -e "${BLUE}Starting development server at $(date '+%I:%M %p, %B %d, %Y')...${RESET}"
    echo -e "${BOLD}${BLUE}${DIVIDER}${RESET}"
    print_status "info" "Starting Livewire development server..."
    echo -e "${BOLD}${BLUE}${DIVIDER}${RESET}"
    
    # Check system requirements
    print_status "step" "Checking system requirements..."
    echo ""
    
    local requirements_met=true
    
    if ! check_php; then
        requirements_met=false
    fi
    
    if ! check_composer_deps; then
        requirements_met=false
    fi
    
    if ! check_env_file; then
        requirements_met=false
    fi
    
    if ! check_app_key; then
        requirements_met=false
    fi
    
    echo ""
    
    if [ "$requirements_met" = false ]; then
        print_status "error" "System requirements not met"
        echo ""
        echo -e "${YELLOW}${BOLD}Alternative:${RESET}"
        echo -e "${YELLOW}Use Laravel Sail instead:${RESET} ${BLUE}./run-sail.sh${RESET}"
        echo -e "${YELLOW}Laravel Sail uses Docker and doesn't require local PHP installation.${RESET}"
        echo ""
        exit 1
    fi
    
    print_status "success" "All system requirements are met!"
    echo ""
    
    # Start the development server
    echo -e "${BOLD}${BLUE}${DIVIDER}${RESET}"
    print_status "step" "Starting Laravel development server..."
    echo ""
    
    echo -e "${GREEN}${BOLD}Server Information:${RESET}"
    echo -e "${GREEN}• URL:${RESET} http://localhost:8008"
    echo -e "${GREEN}• Host:${RESET} 0.0.0.0 (accessible from network)"
    echo -e "${GREEN}• Port:${RESET} 8008"
    echo ""
    
    echo -e "${YELLOW}${BOLD}Important Notes:${RESET}"
    echo -e "${YELLOW}• You MUST run Vite for CSS/JS compilation:${RESET} ${BLUE}npm run dev${RESET}"
    echo -e "${YELLOW}• Or build assets for production:${RESET} ${BLUE}npm run build${RESET}"
    echo -e "${YELLOW}• For background jobs, run:${RESET} ${BLUE}php artisan queue:work -v${RESET}"
    echo ""
    
    echo -e "${BLUE}${BOLD}Starting server...${RESET}"
    echo -e "${BOLD}${BLUE}${DIVIDER}${RESET}"
    
    # Start the server
    php artisan serve --host=0.0.0.0 --port=8008
}

# Run the main function
main "$@"