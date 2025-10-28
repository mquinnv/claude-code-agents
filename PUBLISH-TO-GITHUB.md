# Publishing to GitHub

Your repository is ready! Follow these steps to publish it.

## Quick Start

```bash
# 1. Create the repository on GitHub
gh repo create claude-code-agents --public --source=. --remote=origin

# 2. Push to GitHub
git push -u origin main
```

## Manual Steps

If you prefer to create the repository manually:

### 1. Create GitHub Repository

Go to https://github.com/new and create a new repository:

- **Name**: `claude-code-agents` (or your preferred name)
- **Description**: "Specialized agent definitions for Claude Code with comprehensive tooling"
- **Public** or **Private**: Your choice
- **Don't** initialize with README, .gitignore, or license (we already have these)

### 2. Add Remote and Push

```bash
# Replace YOUR_USERNAME with your GitHub username
git remote add origin https://github.com/YOUR_USERNAME/claude-code-agents.git

# Or use SSH (if configured)
git remote add origin git@github.com:YOUR_USERNAME/claude-code-agents.git

# Push to GitHub
git push -u origin main
```

## Verify

After pushing, visit your repository:
```
https://github.com/YOUR_USERNAME/claude-code-agents
```

You should see:
- ✅ 39 agent definitions
- ✅ Comprehensive README
- ✅ Installation script
- ✅ License file
- ✅ Tool documentation

## Recommended: Add Topics

Add these topics to make your repository discoverable:

```
claude-code
ai-agents
development-tools
devops
security
code-analysis
automation
```

On GitHub: Settings → Topics → Add topics

## Recommended: Add Repository Details

On your GitHub repository page:
- **Description**: "39+ specialized Claude Code agents with comprehensive tooling for development, security, testing, and infrastructure"
- **Website**: Link to Claude Code docs
- **Topics**: claude-code, ai-agents, devops, security, automation

## Share with Your Team

Once published, your coworkers can install with:

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/claude-code-agents.git
cd claude-code-agents

# Install tools
./install-dev-tools.sh

# Copy agents to Claude Code
cp *.md ~/.claude/agents/
```

## Keep It Updated

When you make changes:

```bash
# Stage changes
git add .

# Commit
git commit -m "Description of changes"

# Push
git push
```

## Optional: Create Releases

Tag versions for your team:

```bash
git tag -a v1.0.0 -m "Initial release - 39 agents with full tooling"
git push origin v1.0.0
```

On GitHub: Releases → Create a new release

---

Need help? Run:
```bash
gh repo create --help
```

Or visit: https://docs.github.com/en/get-started
