#!/usr/bin/env bash
#
# Claude Code Development Tools Installer
# Installs essential development tools for macOS and Linux
#
# Usage: ./install-dev-tools.sh [--dry-run]
#

set -e

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "🔍 DRY RUN MODE - No packages will be installed"
    echo ""
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "${BLUE}===================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}===================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Execute or print command
execute() {
    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would run: $*"
    else
        "$@"
    fi
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|linuxmint|pop)
                echo "debian"
                ;;
            fedora|rhel|centos|rocky|almalinux)
                echo "fedora"
                ;;
            arch|manjaro|endeavouros)
                echo "arch"
                ;;
            opensuse*|sles)
                echo "opensuse"
                ;;
            *)
                echo "unknown"
                ;;
        esac
    else
        echo "unknown"
    fi
}

# Install Homebrew on macOS
install_homebrew() {
    if ! command_exists brew; then
        print_info "Installing Homebrew..."
        if [[ "$DRY_RUN" == false ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            echo "  Would install Homebrew"
        fi
    else
        print_success "Homebrew already installed"
    fi
}

# Update package manager
update_package_manager() {
    local os=$1
    print_info "Updating package manager..."

    case "$os" in
        macos)
            execute brew update
            ;;
        debian)
            execute sudo apt-get update
            ;;
        fedora)
            execute sudo dnf check-update || true
            ;;
        arch)
            execute sudo pacman -Sy
            ;;
        opensuse)
            execute sudo zypper refresh
            ;;
    esac
}

# Install package based on OS
install_package() {
    local package=$1
    local os=$2
    local alt_name=$3  # Alternative package name for some distros

    if command_exists "$package"; then
        print_success "$package already installed"
        return 0
    fi

    print_info "Installing $package..."

    case "$os" in
        macos)
            execute brew install "$package"
            ;;
        debian)
            execute sudo apt-get install -y "${alt_name:-$package}"
            ;;
        fedora)
            execute sudo dnf install -y "${alt_name:-$package}"
            ;;
        arch)
            execute sudo pacman -S --noconfirm "${alt_name:-$package}"
            ;;
        opensuse)
            execute sudo zypper install -y "${alt_name:-$package}"
            ;;
    esac
}

# Install from GitHub release
install_from_github() {
    local tool=$1
    local repo=$2
    local os=$3

    if command_exists "$tool"; then
        print_success "$tool already installed"
        return 0
    fi

    print_info "Installing $tool from GitHub..."

    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would install $tool from $repo"
        return 0
    fi

    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    # Detect architecture
    local arch=$(uname -m)
    case "$arch" in
        x86_64) arch="amd64" ;;
        aarch64|arm64) arch="arm64" ;;
    esac

    # Download latest release
    local asset_pattern=""
    case "$os" in
        macos)
            asset_pattern="darwin.*${arch}"
            ;;
        *)
            asset_pattern="linux.*${arch}"
            ;;
    esac

    local download_url=$(curl -s "https://api.github.com/repos/${repo}/releases/latest" | \
        grep "browser_download_url.*${asset_pattern}" | \
        cut -d '"' -f 4 | head -1)

    if [[ -z "$download_url" ]]; then
        print_error "Could not find release for $tool"
        cd - >/dev/null
        rm -rf "$temp_dir"
        return 1
    fi

    curl -L -o package "$download_url"

    # Extract and install
    if [[ "$download_url" == *.tar.gz ]]; then
        tar -xzf package
    elif [[ "$download_url" == *.zip ]]; then
        unzip -q package
    fi

    # Find binary and install
    find . -type f -name "$tool" -exec sudo install -m 755 {} /usr/local/bin/ \;

    cd - >/dev/null
    rm -rf "$temp_dir"

    print_success "$tool installed"
}

# Install Python packages
install_python_package() {
    local package=$1

    if command_exists "$package"; then
        print_success "$package already installed"
        return 0
    fi

    print_info "Installing $package via pip..."

    # Ensure pip is installed
    if ! command_exists pip3 && ! command_exists pip; then
        print_warning "pip not found, skipping $package"
        return 1
    fi

    local pip_cmd="pip3"
    if ! command_exists pip3; then
        pip_cmd="pip"
    fi

    execute "$pip_cmd" install --user "$package"
}

# Main installation function
main() {
    print_header "Claude Code Development Tools Installer"

    # Detect OS
    OS=$(detect_os)
    print_info "Detected OS: $OS"
    echo ""

    if [[ "$OS" == "unknown" ]]; then
        print_error "Unsupported operating system"
        exit 1
    fi

    # Install Homebrew on macOS
    if [[ "$OS" == "macos" ]]; then
        install_homebrew
        echo ""
    fi

    # Update package manager
    update_package_manager "$OS"
    echo ""

    # ===================================
    # Core Tools (in most package repos)
    # ===================================
    print_header "Installing Core Tools"

    install_package "jq" "$OS"
    install_package "curl" "$OS"
    install_package "git" "$OS"

    # ripgrep has different names
    case "$OS" in
        debian) install_package "rg" "$OS" "ripgrep" ;;
        *) install_package "ripgrep" "$OS" ;;
    esac

    install_package "shellcheck" "$OS"
    install_package "pandoc" "$OS"
    install_package "cloc" "$OS"

    echo ""

    # ===================================
    # Homebrew/Advanced Tools
    # ===================================
    print_header "Installing Advanced Tools"

    if [[ "$OS" == "macos" ]]; then
        # These are easy on macOS via Homebrew
        install_package "yq" "$OS"
        install_package "fd" "$OS"
        install_package "ast-grep" "$OS"
        install_package "hadolint" "$OS"
        install_package "yamllint" "$OS"
        install_package "tokei" "$OS"
        install_package "hyperfine" "$OS"
        install_package "git-delta" "$OS"
        install_package "lazygit" "$OS"
        install_package "httpie" "$OS"
        install_package "vegeta" "$OS"
        install_package "dive" "$OS"
        install_package "lazydocker" "$OS"
        install_package "mitmproxy" "$OS"
        install_package "pgcli" "$OS"
        install_package "usql" "$OS"
    else
        # Linux - some from repos, some from GitHub

        # Try package manager first for common ones
        case "$OS" in
            debian)
                install_package "fd-find" "$OS" && sudo ln -sf $(which fdfind) /usr/local/bin/fd 2>/dev/null || true
                install_package "yamllint" "$OS"
                install_package "httpie" "$OS"
                ;;
            fedora)
                install_package "fd-find" "$OS"
                install_package "yamllint" "$OS"
                install_package "httpie" "$OS"
                ;;
            arch)
                install_package "fd" "$OS"
                install_package "yamllint" "$OS"
                install_package "httpie" "$OS"
                ;;
        esac

        # Install from GitHub releases
        install_from_github "yq" "mikefarah/yq" "$OS"
        install_from_github "ast-grep" "ast-grep/ast-grep" "$OS"
        install_from_github "hadolint" "hadolint/hadolint" "$OS"
        install_from_github "tokei" "XAMPPRocky/tokei" "$OS"
        install_from_github "hyperfine" "sharkdp/hyperfine" "$OS"
        install_from_github "delta" "dandavison/delta" "$OS"
        install_from_github "lazygit" "jesseduffield/lazygit" "$OS"
        install_from_github "vegeta" "tsenart/vegeta" "$OS"
        install_from_github "dive" "wagoodman/dive" "$OS"
        install_from_github "lazydocker" "jesseduffield/lazydocker" "$OS"
        install_from_github "usql" "xo/usql" "$OS"

        # Python packages
        install_python_package "pgcli"
        install_python_package "mitmproxy"
        install_python_package "yamllint"
    fi

    echo ""

    # ===================================
    # Security Tools
    # ===================================
    print_header "Installing Security Tools"

    if [[ "$OS" == "macos" ]]; then
        install_package "gitleaks" "$OS"
        install_package "trufflehog" "$OS"
        install_package "tfsec" "$OS"
        install_package "semgrep" "$OS"
        install_package "syft" "$OS"
        install_package "grype" "$OS"
        install_package "vale" "$OS"
    else
        install_from_github "gitleaks" "gitleaks/gitleaks" "$OS"
        install_from_github "trufflehog" "trufflesecurity/trufflehog" "$OS"
        install_from_github "tfsec" "aquasecurity/tfsec" "$OS"
        install_from_github "syft" "anchore/syft" "$OS"
        install_from_github "grype" "anchore/grype" "$OS"
        install_from_github "vale" "errata-ai/vale" "$OS"

        # semgrep via pip
        install_python_package "semgrep"
    fi

    echo ""

    # ===================================
    # Verification
    # ===================================
    print_header "Installation Complete!"
    echo ""
    print_info "Verifying installations..."
    echo ""

    TOOLS=(
        "jq" "yq" "fd" "rg" "ast-grep" "semgrep"
        "gitleaks" "trufflehog" "hadolint" "shellcheck"
        "yamllint" "tfsec" "syft" "grype" "httpie"
        "dive" "lazydocker" "tokei" "cloc" "pgcli"
        "usql" "vegeta" "hyperfine" "delta" "lazygit"
        "mitmproxy" "pandoc" "vale"
    )

    INSTALLED=0
    MISSING=0

    for tool in "${TOOLS[@]}"; do
        if command_exists "$tool"; then
            print_success "$tool"
            ((INSTALLED++))
        else
            print_warning "$tool not found"
            ((MISSING++))
        fi
    done

    echo ""
    print_info "Installed: $INSTALLED/$((INSTALLED + MISSING)) tools"

    if [[ $MISSING -gt 0 ]]; then
        echo ""
        print_warning "Some tools could not be installed automatically."
        print_info "You may need to install them manually or check package availability."
    fi

    echo ""
    print_success "Setup complete! 🎉"
    echo ""
    print_info "You may need to restart your shell or run 'source ~/.bashrc' (or ~/.zshrc)"
}

# Run main function
main
