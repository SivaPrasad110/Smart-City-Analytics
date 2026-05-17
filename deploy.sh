#!/bin/bash
# Smart City Analytics - Deployment Script
# Usage: ./deploy.sh [production|staging|local]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="smart-city-analytics"
COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"

echo_red() { echo -e "${RED}$1${NC}"; }
echo_green() { echo -e "${GREEN}$1${NC}"; }
echo_yellow() { echo -e "${YELLOW}$1${NC}"; }

# Check prerequisites
check_prerequisites() {
    echo_yellow "Checking prerequisites..."

    # Check Docker
    if ! command -v docker &> /dev/null; then
        echo_red "Docker is not installed. Please install Docker first."
        exit 1
    fi

    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        echo_red "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi

    echo_green "Prerequisites check passed!"
}

# Load environment variables
load_env() {
    echo_yellow "Loading environment variables..."

    if [ -f "$ENV_FILE" ]; then
        export $(cat $ENV_FILE | grep -v '^#' | xargs)
        echo_green "Environment loaded from $ENV_FILE"
    else
        echo_yellow "Warning: $ENV_FILE not found. Using defaults."
    fi
}

# Create necessary directories
create_dirs() {
    echo_yellow "Creating necessary directories..."
    mkdir -p logs
    mkdir -p uploads
    mkdir -p models
    echo_green "Directories created!"
}

# Build Docker images
build_images() {
    echo_yellow "Building Docker images..."

    docker-compose -f $COMPOSE_FILE build --no-cache backend
    docker-compose -f $COMPOSE_FILE build frontend

    echo_green "Images built successfully!"
}

# Start services
start_services() {
    echo_yellow "Starting services..."

    docker-compose -f $COMPOSE_FILE up -d

    echo_green "Services started!"
}

# Wait for database
wait_for_db() {
    echo_yellow "Waiting for database to be ready..."

    max_attempts=30
    attempt=1

    while [ $attempt -le $max_attempts ]; do
        if docker exec smartcity-db pg_isready -U postgres &> /dev/null; then
            echo_green "Database is ready!"
            return 0
        fi

        echo "Attempt $attempt/$max_attempts - waiting..."
        sleep 2
        attempt=$((attempt + 1))
    done

    echo_red "Database failed to start after $max_attempts attempts"
    return 1
}

# Check health
check_health() {
    echo_yellow "Checking service health..."

    # Backend health
    max_attempts=10
    attempt=1

    while [ $attempt -le $max_attempts ]; do
        if curl -sf http://localhost:8000/health &> /dev/null; then
            echo_green "Backend is healthy!"
            break
        fi

        echo "Waiting for backend... Attempt $attempt/$max_attempts"
        sleep 3
        attempt=$((attempt + 1))
    done

    # Frontend health
    attempt=1
    while [ $attempt -le $max_attempts ]; do
        if curl -sf http://localhost:3000 &> /dev/null; then
            echo_green "Frontend is accessible!"
            break
        fi

        echo "Waiting for frontend... Attempt $attempt/$max_attempts"
        sleep 3
        attempt=$((attempt + 1))
    done
}

# Show status
show_status() {
    echo ""
    echo_green "========================================="
    echo_green "  Smart City Analytics Deployed!"
    echo_green "========================================="
    echo ""
    echo "  Frontend:  http://localhost:3000"
    echo "  Backend:   http://localhost:8000"
    echo "  API Docs:  http://localhost:8000/docs"
    echo "  Health:    http://localhost:8000/health"
    echo ""
    echo_green "========================================="
    echo ""
    echo "Useful commands:"
    echo "  View logs:     docker-compose logs -f"
    echo "  Stop services: docker-compose down"
    echo "  Restart:       docker-compose restart"
    echo ""
}

# Main deployment function
deploy() {
    echo ""
    echo_yellow "========================================="
    echo_yellow "  Smart City Analytics Deployment"
    echo_yellow "========================================="
    echo ""

    check_prerequisites
    load_env
    create_dirs
    build_images
    start_services
    wait_for_db
    check_health
    show_status
}

# Scale services (for production)
scale() {
    local replicas=${1:-2}

    echo_yellow "Scaling backend to $replicas replicas..."
    docker-compose -f $COMPOSE_FILE up -d --scale backend=$replicas
    echo_green "Backend scaled!"
}

# Clean up
cleanup() {
    echo_yellow "Cleaning up containers, volumes, and images..."

    docker-compose -f $COMPOSE_FILE down -v --remove-orphans
    docker system prune -f

    echo_green "Cleanup complete!"
}

# Show logs
logs() {
    local service=${1:-""}

    if [ -z "$service" ]; then
        docker-compose -f $COMPOSE_FILE logs -f
    else
        docker-compose -f $COMPOSE_FILE logs -f "$service"
    fi
}

# Show help
show_help() {
    echo "Smart City Analytics Deployment Script"
    echo ""
    echo "Usage: ./deploy.sh [command]"
    echo ""
    echo "Commands:"
    echo "  deploy      - Deploy the full application"
    echo "  scale N     - Scale backend to N replicas"
    echo "  cleanup     - Stop services and clean up"
    echo "  logs [svc]  - View logs (optionally for a service)"
    echo "  help        - Show this help message"
    echo ""
}

# Parse command
case "${1:-deploy}" in
    deploy)
        deploy
        ;;
    scale)
        scale "${2:-2}"
        ;;
    cleanup)
        cleanup
        ;;
    logs)
        logs "${2}"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo_red "Unknown command: $1"
        show_help
        exit 1
        ;;
esac