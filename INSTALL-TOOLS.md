# Claude Code Development Tools Installer

Automated installation script for essential development tools used by Claude Code agents and the main assistant.

## Quick Start

```bash
# Preview what will be installed (recommended first)
./install-dev-tools.sh --dry-run

# Install all tools
./install-dev-tools.sh
```

## Supported Platforms

- **macOS** (via Homebrew)
- **Ubuntu/Debian** (apt)
- **Fedora/RHEL/CentOS/Rocky/AlmaLinux** (dnf)
- **Arch/Manjaro/EndeavourOS** (pacman)
- **openSUSE/SLES** (zypper)

## What Gets Installed

### Universal Tools (28 total)

#### JSON/YAML Processing
- **jq** - Command-line JSON processor
- **yq** - YAML processor (like jq for YAML)

#### File & Text Search
- **fd** - Fast file finder (better than find)
- **ripgrep (rg)** - Fast text search (better than grep)

#### Code Analysis & Quality
- **ast-grep** - Structural code search and transformation
- **semgrep** - Static analysis for bugs and security
- **tokei** - Fast code statistics
- **cloc** - Count lines of code
- **shellcheck** - Shell script linter
- **yamllint** - YAML linter

#### Security & Compliance
- **gitleaks** - Secret scanning in git repos
- **trufflehog** - Find credentials in git history
- **tfsec** - Terraform security scanner
- **syft** - SBOM (Software Bill of Materials) generator
- **grype** - Vulnerability scanner for containers
- **vale** - Prose/documentation linter

#### Container & Docker
- **hadolint** - Dockerfile linter
- **dive** - Docker image layer analyzer
- **lazydocker** - Docker terminal UI

#### API & Testing
- **httpie** - User-friendly HTTP client (better than curl)
- **vegeta** - HTTP load testing tool
- **hyperfine** - Command-line benchmarking
- **mitmproxy** - HTTP/HTTPS proxy for debugging

#### Database
- **pgcli** - Postgres CLI with autocomplete
- **usql** - Universal SQL CLI (supports all databases)

#### Git Tools
- **git-delta** - Better git diff viewer
- **lazygit** - Git terminal UI

#### Documentation
- **pandoc** - Universal document converter

## Installation Methods

The script intelligently chooses the best installation method:

### macOS
Uses **Homebrew** for all packages (most reliable on macOS)

### Linux
Combination of methods:
1. **Native package manager** when available (apt, dnf, pacman, zypper)
2. **GitHub releases** for tools not in repos
3. **pip** for Python-based tools (semgrep, pgcli, mitmproxy)

## Requirements

### macOS
- macOS 10.15 or later
- Command Line Tools will be installed automatically with Homebrew

### Linux
- sudo access for package installation
- Python 3.6+ (for pip-based tools)
- curl (installed automatically if missing)
- git (installed automatically if missing)

## Dry Run Mode

Test what will be installed without making changes:

```bash
./install-dev-tools.sh --dry-run
```

This shows:
- Which OS was detected
- What package manager will be used
- Which tools will be installed
- Which tools are already present

## Manual Installation

If the script fails or you prefer manual installation:

### Via Homebrew (macOS/Linux)
```bash
brew install jq yq fd ripgrep ast-grep semgrep gitleaks \
  trufflehog hadolint shellcheck yamllint tfsec syft grype \
  httpie dive lazydocker tokei cloc pgcli vegeta \
  hyperfine git-delta lazygit mitmproxy pandoc vale

# usql requires a custom tap
brew install xo/xo/usql
```

### Via apt (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install -y jq ripgrep shellcheck pandoc cloc \
  yamllint httpie fd-find

# Python tools
pip3 install --user semgrep pgcli mitmproxy

# Install others from GitHub releases (see script)
```

## Verification

After installation, verify tools are available:

```bash
# Check all tools
for tool in jq yq fd rg ast-grep semgrep gitleaks trufflehog \
  hadolint shellcheck yamllint tfsec syft grype httpie dive \
  lazydocker tokei cloc pgcli usql vegeta hyperfine delta \
  lazygit mitmproxy pandoc vale; do
  command -v $tool >/dev/null && echo "✓ $tool" || echo "✗ $tool"
done
```

## Troubleshooting

### PATH Issues

Some tools may install to user directories. Add to your shell config:

```bash
# ~/.bashrc or ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
```

### Python pip Installations

If pip installs fail, ensure Python 3 and pip are installed:

```bash
# Ubuntu/Debian
sudo apt-get install python3-pip

# Fedora
sudo dnf install python3-pip

# macOS
# pip3 comes with Python from Homebrew
brew install python3
```

### GitHub Rate Limits

If you hit GitHub API rate limits:

1. Wait an hour for the limit to reset
2. Or use a GitHub token:

```bash
export GITHUB_TOKEN="your_token_here"
./install-dev-tools.sh
```

### Missing Tools on Verification

Some tools may have different binary names:
- `fd` might be `fdfind` (Ubuntu/Debian)
- `delta` is the binary for `git-delta`
- Run `which toolname` to verify installation location

## Integration with Claude Code

These tools are configured for use in:

1. **Main Claude Code assistant** - via `settings.local.json` permissions
2. **Specialized agents** - via agent tool lists in `.claude/agents/*.md`
3. **Global preferences** - via `.claude/CLAUDE.md` tool usage guidelines

See `.claude/CLAUDE.md` for automatic tool usage preferences.

## Updating Tools

Re-run the script to update tools:

```bash
./install-dev-tools.sh
```

On macOS:
```bash
brew upgrade
```

On Linux:
```bash
# Update package manager
sudo apt update && sudo apt upgrade  # Debian/Ubuntu
sudo dnf upgrade                      # Fedora

# Update pip packages
pip3 install --upgrade semgrep pgcli mitmproxy

# GitHub-installed tools need manual updates or re-run script
```

## Uninstalling

To remove tools:

### macOS
```bash
brew uninstall jq yq fd ripgrep ast-grep semgrep gitleaks \
  trufflehog hadolint shellcheck yamllint tfsec syft grype \
  httpie dive lazydocker tokei cloc pgcli usql vegeta \
  hyperfine git-delta lazygit mitmproxy pandoc vale
```

### Linux
Use your package manager's remove command, or for GitHub-installed tools:
```bash
sudo rm /usr/local/bin/{yq,ast-grep,hadolint,tokei,hyperfine,delta,lazygit,vegeta,dive,lazydocker,usql,gitleaks,trufflehog,tfsec,syft,grype,vale}
```

## License

This installer script is provided as-is for use with Claude Code.

## Contributing

Found an issue or want to add support for another platform? The script is designed to be extensible.

Key functions to modify:
- `detect_os()` - Add OS detection
- `install_package()` - Add package manager support
- `install_from_github()` - Modify GitHub release download logic

## Support

For issues with:
- **The script itself**: Check the troubleshooting section above
- **Individual tools**: Consult the tool's official documentation
- **Claude Code**: See https://docs.claude.com/claude-code
