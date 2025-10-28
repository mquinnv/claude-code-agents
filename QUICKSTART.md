# Quick Start Guide

Get up and running with Claude Code agents in 5 minutes.

## Prerequisites

- **Claude Code** installed and configured
- **macOS** or **Linux** (Ubuntu, Fedora, Arch, openSUSE)
- **Terminal** access
- **Git** installed

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/mquinnv/claude-code-agents.git
cd claude-code-agents
```

### 2. Install Development Tools

This installs 28 essential tools (jq, semgrep, gitleaks, etc.):

```bash
# Preview what will be installed (recommended first)
./install-dev-tools.sh --dry-run

# Install all tools
./install-dev-tools.sh
```

**Time:** ~5-10 minutes depending on your internet connection

### 3. Add Tool Permissions

Allow Claude Code to use the installed tools:

```bash
# Preview changes (recommended)
./add-tool-permissions.sh --dry-run

# Add permissions
./add-tool-permissions.sh
```

**What this does:** Updates `~/.claude/settings.local.json` to allow Claude Code to invoke the tools via Bash.

### 4. Install Agents

Copy agent definitions to Claude Code:

```bash
cp *.md ~/.claude/agents/
```

**What this installs:** 39 specialized agent definitions covering development, security, testing, infrastructure, and more.

### 5. (Optional) Configure Tool Usage Preferences

Add automatic tool usage preferences to your Claude Code configuration:

```bash
cat >> ~/.claude/CLAUDE.md << 'EOF'

## Tool Usage Preferences
### Always Prefer These Tools Over Alternatives
- **jq** - Always use for JSON parsing/manipulation instead of manual parsing
- **semgrep** - Run when reviewing code for bugs, security issues, or best practices
- **gitleaks** - Run on repos before commits when security is a concern
- **httpie** - Prefer over curl for API testing/debugging
- **pgcli** - Prefer over psql for interactive database work

### General Principles
- Use jq/yq liberally for JSON/YAML parsing
- Run linters (shellcheck, hadolint, yamllint) before code is "done"
- Security tools (gitleaks, semgrep) should be proactive, not just on request
EOF
```

### 6. Restart Claude Code

For tool permissions to take effect:

```bash
# Exit Claude Code and restart it
```

## Verification

### Test Agent Installation

In Claude Code, ask:
```
List available agents
```

You should see all 39 agents.

### Test Tool Permissions

Ask Claude Code to:
```
Use jq to parse this JSON: {"name": "test", "value": 42}
```

Claude Code should execute `jq` successfully.

### Test Agents

Ask Claude Code to:
```
Have the backend-developer agent create a simple REST API endpoint
```

The agent should be invoked with all necessary tools available.

## What You Get

✅ **39 Specialized Agents:**
- 11 Development agents (backend, frontend, fullstack, etc.)
- 3 Security agents (security-engineer, security-auditor, compliance)
- 4 Testing agents (qa-expert, test-automator, etc.)
- 6 Infrastructure agents (devops, kubernetes, cloud, etc.)
- And more...

✅ **28 Development Tools:**
- Code analysis: ast-grep, semgrep, tokei
- Security: gitleaks, trufflehog, tfsec, syft, grype
- Infrastructure: yq, kubectl tools, terraform tools
- Database: pgcli, usql
- Performance: vegeta, hyperfine
- And more...

✅ **Enhanced Claude Code:**
- Main assistant can use all tools directly
- Agents have comprehensive tooling
- Automatic tool preferences configured

## Common Issues

### "Permission denied" when running scripts

```bash
chmod +x install-dev-tools.sh add-tool-permissions.sh
```

### Tools not found after installation

Add to your shell config (`~/.bashrc` or `~/.zshrc`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then restart your terminal.

### jq not found during add-tool-permissions.sh

Install jq first:

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# Or run the full install script
./install-dev-tools.sh
```

### Claude Code doesn't see new agents

Make sure you copied them to the right location:

```bash
ls ~/.claude/agents/*.md
```

Should show all 39+ agent files.

### Changes not taking effect

Restart Claude Code completely (not just the conversation).

## Next Steps

### Learn About Agents

Read about specific agents:
- [README.md](README.md) - Complete agent catalog
- Individual agent files (e.g., `backend-developer.md`)

### Customize Agents

Edit any `.md` file to:
- Add new tools
- Modify expertise areas
- Adjust workflows

Changes take effect immediately.

### Add Your Own Agents

1. Copy an existing agent as a template
2. Modify the frontmatter and content
3. Save to `~/.claude/agents/your-agent.md`

### Install Additional Tools

Edit `install-dev-tools.sh` to add more tools for your workflow.

## Getting Help

- **Tool Installation Issues:** See [INSTALL-TOOLS.md](INSTALL-TOOLS.md)
- **Agent Usage:** See [README.md](README.md)
- **Claude Code Docs:** https://docs.claude.com/claude-code

## Uninstall

### Remove Agents

```bash
rm ~/.claude/agents/*.md
```

### Remove Tools (macOS)

```bash
brew uninstall jq yq fd ripgrep ast-grep semgrep gitleaks \
  trufflehog hadolint shellcheck yamllint tfsec syft grype \
  httpie dive lazydocker tokei cloc pgcli vegeta \
  hyperfine git-delta lazygit mitmproxy pandoc vale

brew uninstall xo/xo/usql
```

### Remove Permissions

Edit `~/.claude/settings.local.json` and remove the tool permissions.

---

**Estimated Total Setup Time:** 10-15 minutes

**Ready to go!** Start using agents in Claude Code immediately. 🚀
