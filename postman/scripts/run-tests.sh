#!/bin/bash

# 🧪 Postman Test Runner Script
# This script runs Postman collections using Newman CLI for automated testing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Default values
COLLECTION_FILE="postman/Reltio-Console-API.postman_collection.json"
ENVIRONMENT_FILE="postman/environments/Development.postman_environment.json"
REPORTERS="cli,htmlextra"
FOLDER=""
ITERATIONS=1
DELAY=0
TIMEOUT=30000

# Function to show usage
show_usage() {
    echo "🧪 Postman Test Runner"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -c, --collection FILE    Collection file (default: $COLLECTION_FILE)"
    echo "  -e, --environment FILE   Environment file (default: $ENVIRONMENT_FILE)"
    echo "  -f, --folder FOLDER      Run specific folder only"
    echo "  -i, --iterations NUM     Number of iterations (default: 1)"
    echo "  -d, --delay MS           Delay between requests in ms (default: 0)"
    echo "  -t, --timeout MS         Request timeout in ms (default: 30000)"
    echo "  -r, --reporters LIST     Reporters (default: cli,htmlextra)"
    echo "  --dev                    Use development environment"
    echo "  --prod                   Use production environment"
    echo "  --usage-only             Run only usage reporting tests"
    echo "  --auth-only              Run only authentication tests"
    echo "  --entitlements-only      Run only entitlements tests"
    echo "  --reports-only           Run only reports tests"
    echo "  -h, --help               Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Run all tests with default settings"
    echo "  $0 --dev                              # Run tests against development"
    echo "  $0 --prod                             # Run tests against production"
    echo "  $0 --usage-only                       # Run only usage reporting tests"
    echo "  $0 -f \"Usage Reporting\"              # Run specific folder"
    echo "  $0 -i 3 -d 1000                       # Run 3 iterations with 1s delay"
    echo ""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--collection)
            COLLECTION_FILE="$2"
            shift 2
            ;;
        -e|--environment)
            ENVIRONMENT_FILE="$2"
            shift 2
            ;;
        -f|--folder)
            FOLDER="$2"
            shift 2
            ;;
        -i|--iterations)
            ITERATIONS="$2"
            shift 2
            ;;
        -d|--delay)
            DELAY="$2"
            shift 2
            ;;
        -t|--timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        -r|--reporters)
            REPORTERS="$2"
            shift 2
            ;;
        --dev)
            ENVIRONMENT_FILE="postman/environments/Development.postman_environment.json"
            shift
            ;;
        --prod)
            ENVIRONMENT_FILE="postman/environments/Production.postman_environment.json"
            shift
            ;;
        --usage-only)
            FOLDER="Usage Reporting"
            shift
            ;;
        --auth-only)
            FOLDER="Authentication"
            shift
            ;;
        --entitlements-only)
            FOLDER="Entitlements"
            shift
            ;;
        --reports-only)
            FOLDER="Reports"
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Check if Newman is installed
if ! command -v newman &> /dev/null; then
    print_error "Newman CLI is not installed. Please install it first:"
    echo "  npm install -g newman"
    echo "  npm install -g newman-reporter-htmlextra"
    exit 1
fi

# Check if collection file exists
if [ ! -f "$COLLECTION_FILE" ]; then
    print_error "Collection file not found: $COLLECTION_FILE"
    exit 1
fi

# Check if environment file exists
if [ ! -f "$ENVIRONMENT_FILE" ]; then
    print_error "Environment file not found: $ENVIRONMENT_FILE"
    exit 1
fi

# Create reports directory
mkdir -p newman-reports

# Build Newman command
NEWMAN_CMD="newman run \"$COLLECTION_FILE\" -e \"$ENVIRONMENT_FILE\""

# Add optional parameters
if [ -n "$FOLDER" ]; then
    NEWMAN_CMD="$NEWMAN_CMD --folder \"$FOLDER\""
fi

NEWMAN_CMD="$NEWMAN_CMD --iterations $ITERATIONS"
NEWMAN_CMD="$NEWMAN_CMD --delay-request $DELAY"
NEWMAN_CMD="$NEWMAN_CMD --timeout-request $TIMEOUT"
NEWMAN_CMD="$NEWMAN_CMD --reporters $REPORTERS"

# Add HTML reporter output
if [[ "$REPORTERS" == *"htmlextra"* ]]; then
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    ENV_NAME=$(basename "$ENVIRONMENT_FILE" .postman_environment.json)
    FOLDER_SUFFIX=""
    if [ -n "$FOLDER" ]; then
        FOLDER_SUFFIX="_${FOLDER// /_}"
    fi
    HTML_REPORT="newman-reports/report_${ENV_NAME}${FOLDER_SUFFIX}_${TIMESTAMP}.html"
    NEWMAN_CMD="$NEWMAN_CMD --reporter-htmlextra-export $HTML_REPORT"
fi

# Display test configuration
print_status "🧪 Running Postman Tests"
echo "Collection: $COLLECTION_FILE"
echo "Environment: $ENVIRONMENT_FILE"
if [ -n "$FOLDER" ]; then
    echo "Folder: $FOLDER"
fi
echo "Iterations: $ITERATIONS"
echo "Delay: ${DELAY}ms"
echo "Timeout: ${TIMEOUT}ms"
echo "Reporters: $REPORTERS"
echo ""

# Run the tests
print_status "Executing tests..."
echo "Command: $NEWMAN_CMD"
echo ""

# Execute Newman
if eval $NEWMAN_CMD; then
    print_success "✅ All tests passed!"
    
    # Show HTML report location if generated
    if [[ "$REPORTERS" == *"htmlextra"* ]] && [ -f "$HTML_REPORT" ]; then
        print_success "📊 HTML report generated: $HTML_REPORT"
        print_status "Open the report in your browser to view detailed results"
    fi
else
    print_error "❌ Some tests failed!"
    exit 1
fi

# Summary
echo ""
print_status "Test Summary:"
echo "  Collection: $(basename "$COLLECTION_FILE")"
echo "  Environment: $(basename "$ENVIRONMENT_FILE" .postman_environment.json)"
if [ -n "$FOLDER" ]; then
    echo "  Folder: $FOLDER"
fi
echo "  Iterations: $ITERATIONS"
echo "  Total Duration: $(date)"
echo ""

print_success "🎉 Test run completed!"