#!/usr/bin/env bash
#
# Add Claude Code Tool Permissions
# Adds all development tools to settings.local.json permissions
#
# Usage: ./add-tool-permissions.sh [--dry-run]
#

set -e

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "🔍 DRY RUN MODE - No changes will be made"
    echo ""
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

print_header() {
    echo -e "${BLUE}===================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}===================================${NC}"
}

# Check if jq is installed
if ! command -v jq >/dev/null 2>&1; then
    print_error "jq is required but not installed."
    echo ""
    echo "Install it with:"
    echo "  macOS:  brew install jq"
    echo "  Linux:  sudo apt-get install jq (or yum/dnf/pacman)"
    echo ""
    echo "Or run: ./install-dev-tools.sh"
    exit 1
fi

# Define the settings file path
SETTINGS_FILE="$HOME/.claude/settings.local.json"
BACKUP_FILE="$HOME/.claude/settings.local.json.backup.$(date +%Y%m%d_%H%M%S)"

# Tool permissions to add
TOOLS=(
    "jq"
    "yq"
    "fd"
    "rg"
    "ripgrep"
    "ast-grep"
    "sg"
    "semgrep"
    "gitleaks"
    "trufflehog"
    "hadolint"
    "shellcheck"
    "yamllint"
    "tfsec"
    "syft"
    "grype"
    "httpie"
    "http"
    "https"
    "dive"
    "lazydocker"
    "tokei"
    "cloc"
    "pgcli"
    "usql"
    "vegeta"
    "hyperfine"
    "git-delta"
    "delta"
    "lazygit"
    "mitmproxy"
    "mitmdump"
    "mitmweb"
    "pandoc"
    "vale"
)

print_header "Claude Code Tool Permissions Setup"
echo ""

# Check if settings file exists
if [[ ! -f "$SETTINGS_FILE" ]]; then
    print_warning "Settings file not found: $SETTINGS_FILE"
    print_info "Creating new settings file..."

    if [[ "$DRY_RUN" == false ]]; then
        # Create directory if it doesn't exist
        mkdir -p "$HOME/.claude"

        # Create new settings file with empty permissions
        cat > "$SETTINGS_FILE" << 'EOF'
{
  "permissions": {
    "allow": [],
    "deny": []
  }
}
EOF
        print_success "Created new settings file"
    else
        echo "  Would create: $SETTINGS_FILE"
    fi
else
    print_success "Found existing settings file"

    # Backup existing file
    if [[ "$DRY_RUN" == false ]]; then
        cp "$SETTINGS_FILE" "$BACKUP_FILE"
        print_success "Backed up to: $BACKUP_FILE"
    else
        echo "  Would backup to: $BACKUP_FILE"
    fi
fi

echo ""
print_info "Processing tool permissions..."
echo ""

# Read existing permissions
if [[ -f "$SETTINGS_FILE" ]]; then
    EXISTING_ALLOW=$(jq -r '.permissions.allow[]? // empty' "$SETTINGS_FILE" 2>/dev/null | sort)
else
    EXISTING_ALLOW=""
fi

# Build list of permissions to add
NEW_PERMISSIONS=()
SKIPPED_PERMISSIONS=()

for tool in "${TOOLS[@]}"; do
    PERMISSION="Bash($tool:*)"

    # Check if permission already exists
    if echo "$EXISTING_ALLOW" | grep -Fxq "$PERMISSION"; then
        SKIPPED_PERMISSIONS+=("$tool")
    else
        NEW_PERMISSIONS+=("$tool")
    fi
done

# Report what will be added
if [[ ${#SKIPPED_PERMISSIONS[@]} -gt 0 ]]; then
    print_info "Already permitted (${#SKIPPED_PERMISSIONS[@]} tools):"
    for tool in "${SKIPPED_PERMISSIONS[@]}"; do
        echo "  - $tool"
    done
    echo ""
fi

if [[ ${#NEW_PERMISSIONS[@]} -eq 0 ]]; then
    print_success "All tools are already permitted!"
    echo ""
    print_info "No changes needed."
    exit 0
fi

print_info "Will add permissions for ${#NEW_PERMISSIONS[@]} tools:"
for tool in "${NEW_PERMISSIONS[@]}"; do
    echo "  + $tool"
done
echo ""

# Add permissions using jq
if [[ "$DRY_RUN" == false ]]; then
    # Create temporary file
    TEMP_FILE=$(mktemp)

    # Build jq command to add all new permissions
    JQ_COMMAND='.permissions.allow'
    for tool in "${NEW_PERMISSIONS[@]}"; do
        JQ_COMMAND="$JQ_COMMAND + [\"Bash($tool:*)\"]"
    done
    JQ_COMMAND="$JQ_COMMAND | unique | {permissions: {allow: ., deny: .permissions.deny}}"

    # Apply the changes
    jq "$JQ_COMMAND" "$SETTINGS_FILE" > "$TEMP_FILE"

    # Verify the output is valid JSON
    if jq empty "$TEMP_FILE" 2>/dev/null; then
        mv "$TEMP_FILE" "$SETTINGS_FILE"
        print_success "Successfully updated $SETTINGS_FILE"
    else
        print_error "Failed to update settings file (invalid JSON produced)"
        rm "$TEMP_FILE"
        print_info "Your original file is safe. Backup: $BACKUP_FILE"
        exit 1
    fi
else
    echo "  Would update: $SETTINGS_FILE"
fi

echo ""
print_header "Setup Complete!"
echo ""

if [[ "$DRY_RUN" == false ]]; then
    print_success "Added permissions for ${#NEW_PERMISSIONS[@]} tools"
    echo ""
    print_info "Tool permissions have been updated in:"
    echo "  $SETTINGS_FILE"
    echo ""
    print_info "Backup saved to:"
    echo "  $BACKUP_FILE"
    echo ""
    print_warning "You may need to restart Claude Code for changes to take effect"
else
    print_info "Run without --dry-run to apply changes"
fi

echo ""

# Show example usage
cat << 'EOF'
These tools are now available for Claude Code to use via Bash:

Example commands:
  - jq '.field' file.json
  - semgrep --config auto .
  - gitleaks detect
  - httpie GET api.example.com/endpoint
  - tokei
  - pgcli mydb

See your CLAUDE.md for automatic tool usage preferences.
EOF

echo ""
