#!/usr/bin/env bash

# Load the ANSI library
source ./scripts/ansi 2>/dev/null || {
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
RED=$(ansi::red)
GREEN=$(ansi::green)
YELLOW=$(ansi::yellow)
BLUE=$(ansi::blue)
MAGENTA=$(ansi::magenta)
CYAN=$(ansi::cyan)
WHITE=$(ansi::white)
BOLD=$(ansi::bold)
RESET=$(ansi::reset)

# Divider for visual separation
DIVIDER="=========================================="

# Print status function
print_status() {
    local type=$1
    local message=$2
    
    case $type in
        "info")
            echo -e "${BLUE}ℹ️  ${message}${RESET}"
            ;;
        "success")
            echo -e "${GREEN}✅ ${message}${RESET}"
            ;;
        "warning")
            echo -e "${YELLOW}⚠️  ${message}${RESET}"
            ;;
        "error")
            echo -e "${RED}❌ ${message}${RESET}"
            ;;
        "step")
            echo -e "${CYAN}🔧 ${message}${RESET}"
            ;;
    esac
}

# Check if Docker is installed and running
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_status "error" "Docker is not installed"
        echo ""
        echo -e "${YELLOW}${BOLD}Solution:${RESET}"
        echo -e "${YELLOW}Install Docker Desktop or Docker Engine${RESET}"
        echo ""
        echo -e "${BLUE}${BOLD}Installation guides:${RESET}"
        echo -e "${BLUE}• Docker Desktop:${RESET} https://www.docker.com/products/docker-desktop"
        echo -e "${BLUE}• Docker Engine:${RESET} https://docs.docker.com/engine/install/"
        echo ""
        return 1
    fi
    
    if ! docker info &> /dev/null; then
        print_status "error" "Docker is not running"
        echo ""
        echo -e "${YELLOW}${BOLD}Solution:${RESET}"
        echo -e "${YELLOW}Start Docker Desktop or Docker daemon${RESET}"
        echo ""
        return 1
    fi
    
    print_status "success" "Docker is installed and running"
    return 0
}

# Check if Docker Compose is available
check_docker_compose() {
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_status "error" "Docker Compose is not available"
        echo ""
        echo -e "${YELLOW}${BOLD}Solution:${RESET}"
        echo -e "${YELLOW}Install Docker Compose or use Docker Desktop (includes Compose)${RESET}"
        echo ""
        return 1
    fi
    
    print_status "success" "Docker Compose is available"
    return 0
}

# Check if Laravel Sail is installed
check_sail() {
    if [ ! -f "vendor/bin/sail" ]; then
        print_status "error" "Laravel Sail is not installed"
        echo ""
        echo -e "${YELLOW}${BOLD}Solution:${RESET}"
        echo -e "${YELLOW}Run the setup script first:${RESET} ${CYAN}./setup.sh${RESET}"
        echo -e "${YELLOW}Or install Sail manually:${RESET} ${CYAN}composer require laravel/sail --dev${RESET}"
        echo ""
        return 1
    fi
    
    print_status "success" "Laravel Sail is installed"
    return 0
}

# Check if .env file exists
check_env_file() {
    if [ ! -f ".env" ]; then
        print_status "error" ".env file not found"
        echo ""
        echo -e "${YELLOW}${BOLD}Solution:${RESET}"
        echo -e "${YELLOW}Run the setup script first:${RESET} ${CYAN}./setup.sh${RESET}"
        echo ""
        return 1
    fi
    
    print_status "success" ".env file exists"
    return 0
}

# Check if docker-compose.yml exists
check_docker_compose_file() {
    if [ ! -f "docker-compose.yml" ]; then
        print_status "error" "docker-compose.yml file not found"
        echo ""
        echo -e "${YELLOW}${BOLD}Solution:${RESET}"
        echo -e "${YELLOW}Run the setup script first:${RESET} ${CYAN}./setup.sh${RESET}"
        echo -e "${YELLOW}Or publish Sail configuration:${RESET} ${CYAN}php artisan sail:install${RESET}"
        echo ""
        return 1
    fi
    
    print_status "success" "docker-compose.yml file exists"
    return 0
}

# Main function
main() {
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
    echo -e "${RESET}Livewire Sail Run Script - v1.0${RESET}"
    echo -e "${BLUE}Starting Laravel Sail at $(date '+%I:%M %p, %B %d, %Y')...${RESET}"
    echo -e "${BOLD}${BLUE}${DIVIDER}${RESET}"
    print_status "info" "Starting Livewire with Laravel Sail..."
    echo -e "${BOLD}${BLUE}${DIVIDER}${RESET}"
    
    # Check system requirements
    print_status "step" "Checking system requirements..."
    echo ""
    
    local requirements_met=true
    
    if ! check_docker; then
        requirements_met=false
    fi
    
    if ! check_docker_compose; then
        requirements_met=false
    fi
    
    if ! check_sail; then
        requirements_met=false
    fi
    
    if ! check_env_file; then
        requirements_met=false
    fi
    
    if ! check_docker_compose_file; then
        requirements_met=false
    fi
    
    echo ""
    
    if [ "$requirements_met" = false ]; then
        print_status "error" "System requirements not met"
        echo ""
        echo -e "${YELLOW}${BOLD}Alternative:${RESET}"
        echo -e "${YELLOW}Use direct PHP instead:${RESET} ${CYAN}./run.sh${RESET}"
        echo -e "${YELLOW}Direct PHP requires local PHP 8.2+ installation.${RESET}"
        echo ""
        exit 1
    fi
    
    print_status "success" "All system requirements are met!"
    echo ""
    
    # Start Laravel Sail
    echo -e "${BOLD}${BLUE}${DIVIDER}${RESET}"
    print_status "step" "Starting Laravel Sail containers..."
    echo ""
    
    echo -e "${GREEN}${BOLD}Server Information:${RESET}"
    echo -e "${GREEN}• URL:${RESET} http://localhost"
    echo -e "${GREEN}• Local Domain:${RESET} huement.local (if configured)"
    echo -e "${GREEN}• Docker Environment:${RESET} Full Laravel stack in containers"
    echo ""
    
    echo -e "${YELLOW}${BOLD}Important Notes:${RESET}"
    echo -e "${YELLOW}• You MUST run Vite for CSS/JS compilation:${RESET}"
    echo -e "  ${CYAN}Option A:${RESET} pm2 start \"./vendor/bin/sail npm run dev\" --name huementlocal"
    echo -e "  ${CYAN}Option B:${RESET} snpm run dev (requires edited .bashrc)"
    echo -e "  ${CYAN}Option C:${RESET} ./vendor/bin/sail npm run dev"
    echo ""
    echo -e "${YELLOW}• For background jobs, run:${RESET}"
    echo -e "  ${CYAN}Option A:${RESET} sartisan queue:work -v (requires edited .bashrc)"
    echo -e "  ${CYAN}Option B:${RESET} ./vendor/bin/sail artisan queue:work -v"
    echo ""
    
    echo -e "${BLUE}${BOLD}Starting Sail containers...${RESET}"
    echo -e "${BOLD}${BLUE}${DIVIDER}${RESET}"
    
    # Start Sail
    ./vendor/bin/sail up -d
    
    if [ $? -eq 0 ]; then
        echo ""
        print_status "success" "Laravel Sail started successfully! 🎉"
        echo ""
        echo -e "${GREEN}${BOLD}Next Steps:${RESET}"
        echo -e "${GREEN}1.${RESET} Start Vite for asset compilation:"
        echo -e "   ${CYAN}./vendor/bin/sail npm run dev${RESET}"
        echo ""
        echo -e "${GREEN}2.${RESET} Open your browser and visit:"
        echo -e "   ${CYAN}http://localhost${RESET}"
        echo ""
        echo -e "${GREEN}3.${RESET} Check container status:"
        echo -e "   ${CYAN}./vendor/bin/sail ps${RESET}"
        echo ""
        echo -e "${GREEN}4.${RESET} Stop containers when done:"
        echo -e "   ${CYAN}./vendor/bin/sail down${RESET}"
        echo ""
        echo -e "${BLUE}${BOLD}Happy coding with Sail! 🚀${RESET}"
    else
        print_status "error" "Failed to start Laravel Sail"
        echo ""
        echo -e "${YELLOW}${BOLD}Troubleshooting:${RESET}"
        echo -e "${YELLOW}• Check Docker is running:${RESET} ${CYAN}docker info${RESET}"
        echo -e "${YELLOW}• Check port availability:${RESET} ${CYAN}netstat -tulpn | grep :80${RESET}"
        echo -e "${YELLOW}• View Sail logs:${RESET} ${CYAN}./vendor/bin/sail logs${RESET}"
        echo ""
        exit 1
    fi
}

# Run the main function
main "$@"