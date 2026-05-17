#!/bin/bash
# Smart City Analytics - Fixed Deployment Script v2.0
# Enhanced with error handling, validation, and safety checks
# Usage: ./deploy-fixed.sh [deploy|scale|cleanup|logs|health|help]

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# ============================================
# CONFIGURATION
# ============================================
PROJECT_NAME="smart-city-analytics"
COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"
LOG_FILE="logs/deploy-$(date +%Y%m%d_%H%M%S).log"
MAX_RETRIES=30
RETRY_INTERVAL=2

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================
# LOGGING FUNCTIONS
# ============================================
log_section() {
    echo "" | tee -a "$LOG_FILE"
    echo -e "${BLUE}========================================${NC}" | tee -a "$LOG_FILE"
    echo -e "${BLUE}  $1${NC}" | tee -a "$LOG_FILE"
    echo -e "${BLUE}========================================${NC}" | tee -a "$LOG_FILE"
}

echo_red() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

echo_green() {
    echo -e "${GREEN}[OK]${NC} $1" | tee -a "$LOG_FILE"
}

echo_yellow() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

echo_blue() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

# ============================================
# ERROR HANDLING & CLEANUP
# ============================================
error_exit() {
    echo_red "$1"
    echo_yellow "Check logs: $LOG_FILE"
    exit 1
}

trap 'echo_red "Deployment interrupted"; exit 1' INT TERM

# ============================================
# VALIDATION FUNCTIONS
# ============================================
check_command() {
    if ! command -v "$1" &> /dev/null; then
        error_exit "$1 is not installed. Please install $1 first."
    fi
}

check_file() {
    if [ ! -f "$1" ]; then
        error_exit "Required file not found: $1"
    fi
}

validate_env() {
    echo_blue "Validating environment configuration..."
    
    if [ ! -f "$ENV_FILE" ]; then
        error_exit "$ENV_FILE not found. Copy from .env.example and configure."
    fi
    
    # Check for dangerous default values
    if grep -q "DB_PASSWORD=smartcity_secure_pass_2024\|SECRET_KEY=super-secret-key-change-me\|JWT_SECRET=jwt-secret-change-me" "$ENV_FILE"; then
        error_exit "ERROR: Using default passwords! Update $ENV_FILE with secure values!"
    fi
    
    # Verify required variables
    for var in "DB_PASSWORD" "SECRET_KEY" "JWT_SECRET"; do
        if ! grep -q "^${var}=" "$ENV_FILE"; then
            error_exit "Missing required variable: $var in $ENV_FILE"
        fi
    done
    
    echo_green "Environment validation passed"
}

validate_docker_compose() {
    echo_blue "Validating Docker Compose configuration..."
    
    if ! docker-compose -f "$COMPOSE_FILE" config > /dev/null 2>&1; then
        error_exit "Invalid Docker Compose configuration"
    fi
    
    echo_green "Docker Compose configuration valid"
}

# ============================================
# PREREQUISITES CHECK
# ============================================
check_prerequisites() {
    log_section "Checking Prerequisites"
    
    echo_blue "Checking required commands..."
    check_command docker
    check_command docker-compose
    check_command curl
    
    echo_blue "Verifying Docker daemon..."
    if ! docker info > /dev/null 2>&1; then
        error_exit "Docker daemon is not running. Please start Docker."
    fi
    
    echo_blue "Checking Docker Compose version..."
    docker-compose --version | tee -a "$LOG_FILE"
    
    echo_green "All prerequisites satisfied"
}

# ============================================
# ENVIRONMENT SETUP
# ============================================
load_env() {
    log_section "Loading Configuration"
    
    validate_env
    validate_docker_compose
    
    # Source environment file safely
    set -a
    # shellcheck disable=SC1090
    [ -f "$ENV_FILE" ] && . "$ENV_FILE"
    set +a
    
    echo_green "Configuration loaded successfully"
}

# ============================================
# DIRECTORY SETUP
# ============================================
create_directories() {
    log_section "Creating Necessary Directories"
    
    local dirs=("logs" "uploads" "models" "backups" "data/postgres")
    
    for dir in "${dirs[@]}"; do
        if mkdir -p "$dir" 2>/dev/null; then
            echo_blue "Created: $dir"
        else
            error_exit "Failed to create directory: $dir"
        fi
    done
    
    echo_green "All directories created"
}

# ============================================
# DOCKER OPERATIONS
# ============================================
build_images() {
    log_section "Building Docker Images"
    
    echo_blue "Building backend image..."
    if ! docker-compose -f "$COMPOSE_FILE" build --no-cache backend 2>&1 | tee -a "$LOG_FILE"; then
        error_exit "Failed to build backend image"
    fi
    
    echo_blue "Building frontend image..."
    if ! docker-compose -f "$COMPOSE_FILE" build frontend 2>&1 | tee -a "$LOG_FILE"; then
        error_exit "Failed to build frontend image"
    fi
    
    echo_green "Images built successfully"
}

start_services() {
    log_section "Starting Services"
    
    echo_blue "Starting containers..."
    if ! docker-compose -f "$COMPOSE_FILE" up -d 2>&1 | tee -a "$LOG_FILE"; then
        error_exit "Failed to start services"
    fi
    
    echo_green "Services started in background"
}

# ============================================
# HEALTH CHECKS WITH RETRY LOGIC
# ============================================
wait_for_service() {
    local service=$1
    local endpoint=$2
    local max_attempts=$3
    local attempt=1
    
    echo_blue "Waiting for $service..."
    
    while [ $attempt -le "$max_attempts" ]; do
        if curl -sf "$endpoint" > /dev/null 2>&1; then
            echo_green "$service is ready (Attempt $attempt/$max_attempts)"
            return 0
        fi
        
        echo_yellow "Attempt $attempt/$max_attempts - $service not ready yet..."
        sleep "$RETRY_INTERVAL"
        attempt=$((attempt + 1))
    done
    
    error_exit "$service failed to become healthy after $max_attempts attempts. Check: docker-compose logs $service"
}

wait_for_db() {
    log_section "Waiting for Database"
    
    # BUG FIX: Get container dynamically instead of hardcoding
    local db_container
    db_container=$(docker-compose -f "$COMPOSE_FILE" ps -q db 2>/dev/null)
    
    if [ -z "$db_container" ]; then
        error_exit "Database container not found"
    fi
    
    echo_blue "Database container: $db_container"
    local attempt=1
    
    while [ $attempt -le "$MAX_RETRIES" ]; do
        if docker exec "$db_container" pg_isready -U postgres -d smartcity &> /dev/null; then
            echo_green "Database is ready (Attempt $attempt/$MAX_RETRIES)"
            return 0
        fi
        
        echo_yellow "Attempt $attempt/$MAX_RETRIES - Waiting for database..."
        sleep "$RETRY_INTERVAL"
        attempt=$((attempt + 1))
    done
    
    error_exit "Database failed to start. Check: docker-compose logs db"
}

check_health() {
    log_section "Checking Service Health"
    
    wait_for_service "Backend API" "http://localhost:8000/health" 15
    wait_for_service "Frontend" "http://localhost:3000" 15
    
    echo_green "All services are healthy"
}

# ============================================
# STATUS & INFORMATION
# ============================================
show_status() {
    log_section "Deployment Complete"
    
    echo ""
    echo -e "${GREEN}✓ Smart City Analytics is running!${NC}"
    echo ""
    echo -e "${BLUE}Access Points:${NC}"
    echo "  • Frontend:      http://localhost:3000"
    echo "  • Backend API:   http://localhost:8000"
    echo "  • API Docs:      http://localhost:8000/docs"
    echo "  • Health Check:  http://localhost:8000/health"
    echo ""
    echo -e "${BLUE}Useful Commands:${NC}"
    echo "  • View all logs:     docker-compose logs -f"
    echo "  • View backend logs: docker-compose logs -f backend"
    echo "  • View frontend logs:docker-compose logs -f frontend"
    echo "  • View db logs:      docker-compose logs -f db"
    echo "  • Stop services:     docker-compose down"
    echo "  • Restart services:  docker-compose restart"
    echo "  • Scale backend:     ./deploy-fixed.sh scale 3"
    echo ""
    echo -e "${BLUE}Log File: $LOG_FILE${NC}"
    echo ""
}

# ============================================
# HELPER FUNCTIONS
# ============================================
scale_services() {
    local replicas=${1:-2}
    
    # BUG FIX: Validate input is numeric
    if ! [[ "$replicas" =~ ^[0-9]+$ ]]; then
        error_exit "Invalid replica count: $replicas (must be a positive integer)"
    fi
    
    if [ "$replicas" -lt 1 ]; then
        error_exit "Replica count must be at least 1"
    fi
    
    log_section "Scaling Backend Services"
    
    echo_blue "Scaling backend to $replicas replicas..."
    if docker-compose -f "$COMPOSE_FILE" up -d --scale backend="$replicas" 2>&1 | tee -a "$LOG_FILE"; then
        echo_green "Backend scaled to $replicas replicas"
    else
        error_exit "Failed to scale services"
    fi
}

cleanup_deployment() {
    log_section "Cleanup"
    
    echo_yellow "This will stop all containers and remove volumes"
    read -p "Continue? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo_blue "Stopping containers..."
        docker-compose -f "$COMPOSE_FILE" down -v --remove-orphans 2>&1 | tee -a "$LOG_FILE" || true
        
        echo_blue "Pruning unused images and volumes..."
        docker system prune -f 2>&1 | tee -a "$LOG_FILE" || true
        
        echo_green "Cleanup complete"
    else
        echo_yellow "Cleanup cancelled"
    fi
}

view_logs() {
    local service=${1:-""}
    
    if [ -z "$service" ]; then
        docker-compose -f "$COMPOSE_FILE" logs -f
    else
        docker-compose -f "$COMPOSE_FILE" logs -f "$service"
    fi
}

show_help() {
    cat << 'EOF'
╔════════════════════════════════════════════════════════════════╗
║  Smart City Analytics - Deployment Script v2.0                ║
║  Fixed Version with Better Error Handling                     ║
╚════════════════════════════════════════════════════════════════╝

USAGE:
  ./deploy-fixed.sh [command] [options]

COMMANDS:
  deploy              Full deployment with all checks
  scale N             Scale backend to N replicas (e.g., scale 5)
  cleanup             Stop all services and clean up resources
  logs [service]      View service logs (backend|frontend|db|all)
  health              Check health status of all services
  help                Show this help message

EXAMPLES:
  ./deploy-fixed.sh deploy          # Complete deployment
  ./deploy-fixed.sh scale 3         # Scale to 3 backends
  ./deploy-fixed.sh logs backend    # View backend logs
  ./deploy-fixed.sh health          # Check health
  ./deploy-fixed.sh cleanup         # Stop and clean up

ENVIRONMENT VARIABLES (in .env):
  DB_PASSWORD         PostgreSQL password (REQUIRED - not default)
  SECRET_KEY          API secret key (REQUIRED - not default)
  JWT_SECRET          JWT signing key (REQUIRED - not default)
  ENVIRONMENT         production|staging|development

IMPORTANT:
  • Copy .env.example to .env
  • Update all passwords and secrets in .env
  • Never commit .env to version control
  • Check logs/deploy-*.log for detailed logs

BUG FIXES IN THIS VERSION:
  ✓ Fixed hardcoded container name (now dynamic)
  ✓ Added environment validation
  ✓ Added input validation for scale command
  ✓ Proper error handling and logging
  ✓ Better health check retries
  ✓ Safer environment file loading

For more info: https://github.com/SivaPrasad110/Smart-City-Analytics
EOF
}

# ============================================
# MAIN DEPLOYMENT FUNCTION
# ============================================
main_deploy() {
    log_section "Smart City Analytics Deployment"
    
    check_prerequisites
    load_env
    create_directories
    build_images
    start_services
    wait_for_db
    check_health
    show_status
}

# ============================================
# COMMAND ROUTING
# ============================================
case "${1:-deploy}" in
    deploy)
        main_deploy
        ;;
    scale)
        load_env
        scale_services "${2:-2}"
        ;;
    cleanup)
        load_env
        cleanup_deployment
        ;;
    logs)
        view_logs "${2:-}"
        ;;
    health)
        load_env
        check_health
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo_red "Unknown command: $1"
        echo "Run './deploy-fixed.sh help' for usage information"
        exit 1
        ;;
esac
