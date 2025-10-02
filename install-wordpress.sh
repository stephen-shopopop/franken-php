#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Define variables
WORDPRESS_URL="https://wordpress.org/latest.tar.gz"
WORDPRESS_TAR="latest.tar.gz"
PLUGIN_URL="https://downloads.wordpress.org/plugin/sqlite-database-integration.zip"
PLUGIN="sqlite-database-integration"
PLUGIN_ZIP="${PLUGIN}.zip"
PLUGIN_DIR="./wordpress/wp-content/plugins"
DB_COPY_SRC="${PLUGIN_DIR}/${PLUGIN}/db.copy"
DB_COPY_DEST="wordpress/wp-content/db.php"
WP_CONFIG="wp-config.php"
WORDPRESS_DIR="wordpress"

# Helper functions
print_info() {
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

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."
    local missing_deps=()

    for cmd in curl tar unzip; do
        if ! command_exists "$cmd"; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_info "Please install them and try again."
        exit 1
    fi

    print_success "All prerequisites are installed"
}

# Check if WordPress is already installed
check_existing_installation() {
    if [ -d "$WORDPRESS_DIR" ]; then
        print_warning "WordPress directory already exists!"
        read -p "Do you want to remove it and reinstall? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Removing existing WordPress installation..."
            rm -rf "$WORDPRESS_DIR"
            print_success "Existing installation removed"
        else
            print_info "Keeping existing installation. Exiting..."
            exit 0
        fi
    fi
}

# Download and extract WordPress
install_wordpress() {
    print_info "Downloading WordPress..."
    if curl -fSL -o "$WORDPRESS_TAR" "$WORDPRESS_URL"; then
        print_success "WordPress downloaded successfully"
    else
        print_error "Failed to download WordPress"
        exit 1
    fi

    print_info "Extracting WordPress..."
    if tar xzf "$WORDPRESS_TAR"; then
        print_success "WordPress extracted successfully"
    else
        print_error "Failed to extract WordPress"
        exit 1
    fi
}

# Install SQLite plugin
install_sqlite_plugin() {
    print_info "Downloading SQLite Database Integration plugin..."
    if curl -fSL -o "$PLUGIN_ZIP" "$PLUGIN_URL"; then
        print_success "Plugin downloaded successfully"
    else
        print_error "Failed to download plugin"
        exit 1
    fi

    print_info "Extracting plugin..."
    if unzip -q -o "$PLUGIN_ZIP"; then
        print_success "Plugin extracted successfully"
    else
        print_error "Failed to extract plugin"
        exit 1
    fi

    print_info "Installing plugin to WordPress..."
    if mv "$PLUGIN" "$PLUGIN_DIR"; then
        print_success "Plugin installed successfully"
    else
        print_error "Failed to install plugin"
        exit 1
    fi

    print_info "Configuring SQLite database..."
    if cp "$DB_COPY_SRC" "$DB_COPY_DEST"; then
        print_success "SQLite database configured"
    else
        print_error "Failed to configure SQLite database"
        exit 1
    fi
}

# Configure WordPress
configure_wordpress() {
    print_info "Configuring WordPress..."
    if [ ! -f "config/$WP_CONFIG" ]; then
        print_error "Configuration file config/$WP_CONFIG not found"
        exit 1
    fi

    if cp "config/$WP_CONFIG" "$WORDPRESS_DIR/$WP_CONFIG"; then
        print_success "WordPress configured successfully"
    else
        print_error "Failed to configure WordPress"
        exit 1
    fi
}

# Install FrankenPHP
install_frankenphp() {
    print_info "Checking if FrankenPHP is already installed..."

    if command_exists frankenphp; then
        print_warning "FrankenPHP is already installed"
        frankenphp version 2>/dev/null || true
        read -p "Do you want to reinstall it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Skipping FrankenPHP installation"
            return 0
        fi
    fi

    print_info "Downloading FrankenPHP installer..."
    if curl -fSL https://frankenphp.dev/install.sh -o /tmp/frankenphp-install.sh; then
        print_success "Installer downloaded"
    else
        print_error "Failed to download FrankenPHP installer"
        exit 1
    fi

    print_info "Installing FrankenPHP..."
    if sh /tmp/frankenphp-install.sh; then
        print_success "FrankenPHP installed"
    else
        print_error "Failed to install FrankenPHP"
        exit 1
    fi

    # Check if we need sudo to move to /usr/local/bin
    # if [ -w /usr/local/bin ]; then
    #    print_info "Moving FrankenPHP to /usr/local/bin..."
    #    mv frankenphp /usr/local/bin/
    # else
    #     print_info "Moving FrankenPHP to /usr/local/bin/ (requires sudo)..."
    #     if sudo mv frankenphp /usr/local/bin/; then
    #         print_success "FrankenPHP installed globally"
    #     else
    #         print_warning "Failed to install globally. FrankenPHP is available in current directory"
    #     fi
    # fi

    # Clean up
    rm -f /tmp/frankenphp-install.sh
}

# Clean up temporary files
cleanup() {
    print_info "Cleaning up temporary files..."
    rm -f "$PLUGIN_ZIP" "$WORDPRESS_TAR"
    print_success "Cleanup completed"
}

# Main installation process
main() {
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}WordPress + FrankenPHP Installer${NC}"
    echo -e "${GREEN}================================${NC}"
    echo

    check_prerequisites
    check_existing_installation
    install_wordpress
    install_sqlite_plugin
    configure_wordpress
    cleanup
    install_frankenphp

    echo
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}Installation completed!${NC}"
    echo -e "${GREEN}================================${NC}"
    echo
    print_info "To start WordPress, run:"
    echo -e "  ${YELLOW}./frankenphp php-server -r wordpress/${NC}"
    echo
    print_info "Or use caddy:"
    echo -e "  ${YELLOW}./frankenphp run${NC}"
    echo
    print_info "Then access your site at: ${YELLOW}http://localhost${NC}"
    echo
}

# Run main function
main "$@"
