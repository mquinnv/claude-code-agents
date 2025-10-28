# Claude Code Agent Definitions

A comprehensive collection of specialized agent definitions for Claude Code, covering development, security, testing, infrastructure, and more.

## Overview

This repository contains 39+ specialized agent definitions that extend Claude Code's capabilities with domain expertise, specialized tooling, and focused workflows.

## Quick Start

### Installation

1. **Clone this repository:**
   ```bash
   git clone <your-repo-url>
   cd claude-code-agents
   ```

2. **Copy agents to your Claude Code directory:**
   ```bash
   cp *.md ~/.claude/agents/
   ```

3. **Install recommended tools:**
   See [INSTALL-TOOLS.md](INSTALL-TOOLS.md) for the installation script

### Using Agents

Agents are invoked via the Task tool in Claude Code:

```
I need to optimize this database query
```

Claude Code will automatically select the appropriate agent (e.g., `database-optimizer`) based on the task.

You can also explicitly request an agent:
```
Use the security-auditor agent to review this code for vulnerabilities
```

## Agent Categories

### 🔧 Core Development (11 agents)

| Agent | Description | Key Tools |
|-------|-------------|-----------|
| **backend-developer** | Scalable API development, microservices | Docker, PostgreSQL, Redis, semgrep |
| **frontend-developer** | React/Vue/Angular UI development | Playwright, magic, context7 |
| **fullstack-developer** | End-to-end feature development | Full stack + testing tools |
| **typescript-pro** | Advanced TypeScript, type safety | tsc, eslint, jest, vite |
| **nuxtjs-developer** | Nuxt 3 SSR/SSG applications | Nuxt, Nitro, Pinia, Prisma |
| **java-architect** | Enterprise Java, Spring ecosystem | Maven, Gradle, JUnit |
| **kotlin-specialist** | Kotlin coroutines, multiplatform | Gradle, detekt, ktlint |
| **mobile-app-developer** | iOS/Android native & cross-platform | Xcode, Android Studio, Flutter |
| **graphql-architect** | GraphQL schema design, federation | Apollo, graphql-codegen |
| **websocket-engineer** | Real-time communication systems | Socket.IO, Redis pub/sub |
| **payment-integration** | Payment gateways, PCI compliance | Stripe, PayPal, Square |

### 🔒 Security & Compliance (3 agents)

| Agent | Description | Key Tools |
|-------|-------------|-----------|
| **security-engineer** | DevSecOps, cloud security | gitleaks, trufflehog, grype, syft |
| **security-auditor** | Security assessments, compliance | semgrep, prowler, scout suite |
| **compliance-auditor** | GDPR, HIPAA, SOC 2, ISO | syft, gitleaks, checkov |

### 🧪 Testing & Quality (4 agents)

| Agent | Description | Key Tools |
|-------|-------------|-----------|
| **qa-expert** | Test strategy, quality metrics | Selenium, Cypress, Playwright |
| **test-automator** | Test frameworks, CI/CD integration | pytest, jest, k6 |
| **code-reviewer** | Code quality, security review | semgrep, ast-grep, tokei |
| **accessibility-tester** | WCAG compliance, a11y testing | axe, wave, lighthouse |

### ☁️ Infrastructure & DevOps (6 agents)

| Agent | Description | Key Tools |
|-------|-------------|-----------|
| **devops-engineer** | CI/CD, containerization, automation | Docker, Kubernetes, Terraform |
| **kubernetes-specialist** | K8s orchestration, deployments | kubectl, Helm, k9s |
| **cloud-architect** | Multi-cloud architecture, AWS/GCP/Azure | aws-cli, terraform, kubectl |
| **devops-incident-responder** | Production issue resolution | PagerDuty, Datadog, Grafana |
| **incident-responder** | Security incident management | PagerDuty, Opsgenie, Slack |
| **error-coordinator** | Distributed error handling | Sentry, circuit-breaker |

### 🗄️ Database (3 agents)

| Agent | Description | Key Tools |
|-------|-------------|-----------|
| **database-administrator** | High-availability, disaster recovery | PostgreSQL, MySQL, MongoDB |
| **database-optimizer** | Query optimization, performance tuning | pgcli, explain, analyze |
| **sql-pro** | Complex queries, database design | psql, mysql, sqlite3 |

### 🎨 Design & UX (2 agents)

| Agent | Description | Key Tools |
|-------|-------------|-----------|
| **ui-designer** | Visual design, design systems | Figma, Sketch, Adobe XD |
| **ux-researcher** | User insights, usability testing | Figma, Miro, Hotjar |

### 📊 Performance & Analysis (2 agents)

| Agent | Description | Key Tools |
|-------|-------------|-----------|
| **performance-engineer** | Optimization, load testing | vegeta, hyperfine, flamegraph |
| **refactoring-specialist** | Code transformation, complexity reduction | ast-grep, semgrep, jscodeshift |

### 📝 Documentation & API (3 agents)

| Agent | Description | Key Tools |
|-------|-------------|-----------|
| **technical-writer** | Documentation, user guides | pandoc, vale, markdown |
| **api-designer** | REST/GraphQL API design | OpenAPI, Postman, Spectral |
| **api-documenter** | API documentation, dev portals | Swagger, Redoc, Slate |

### 🔧 Specialized Agents (5 agents)

| Agent | Description | Key Tools |
|-------|-------------|-----------|
| **debugger** | Complex issue diagnosis, RCA | gdb, lldb, strace |
| **agent-organizer** | Multi-agent orchestration | Task queue, monitoring |
| **legal-advisor** | Tech law, compliance, IP | pandoc, docusign |

## Agent Architecture

Each agent definition follows this structure:

```markdown
---
name: agent-name
description: Brief description of agent's expertise
tools: Tool1, Tool2, Tool3, ...
model: sonnet
color: green
---

Agent prompt and instructions...
```

### Key Components

- **name**: Unique identifier for the agent
- **description**: Used by Claude Code to select appropriate agent
- **tools**: Available CLI tools and specialized software
- **model**: Claude model to use (sonnet, opus, haiku)
- **color**: Terminal output color (cosmetic)

## Tool Requirements

Many agents require specialized tools. Install them using:

```bash
# Run the installation script (recommended)
./install-dev-tools.sh

# Or install via Homebrew (macOS)
brew install jq yq fd ripgrep ast-grep semgrep gitleaks \
  trufflehog hadolint shellcheck yamllint tfsec syft grype \
  httpie dive lazydocker tokei cloc pgcli vegeta \
  hyperfine git-delta lazygit mitmproxy pandoc vale

# usql requires a custom tap
brew install xo/xo/usql
```

See [INSTALL-TOOLS.md](INSTALL-TOOLS.md) for detailed installation instructions.

## Common Tool Categories

### Universal Tools (all agents)
- **Read, Write, MultiEdit** - File operations
- **Bash** - Command execution
- **Grep, Glob** - Search and pattern matching
- **git-delta, lazygit** - Enhanced git operations
- **jq** - JSON processing (32 agents)

### Code Analysis
- **ast-grep** - Structural code search
- **semgrep** - Security and bug detection
- **tokei/cloc** - Code metrics

### Security
- **gitleaks, trufflehog** - Secret scanning
- **tfsec** - Terraform security
- **syft, grype** - SBOM and vulnerability scanning

### Infrastructure
- **yq** - YAML processing
- **shellcheck, yamllint, hadolint** - Config linting
- **dive, lazydocker** - Container tools

## Customization

### Creating Your Own Agent

1. Copy an existing agent as a template
2. Modify the frontmatter (name, description, tools)
3. Update the prompt with your specific expertise
4. Save to `~/.claude/agents/your-agent.md`

### Modifying Existing Agents

Edit any `.md` file to:
- Add new tools
- Adjust expertise areas
- Change workflows
- Update checklists

Changes take effect immediately.

## Best Practices

### Tool Selection
- **Core tools**: Always include Read, Write, MultiEdit, Bash, Grep, Glob
- **Domain tools**: Add specialized CLIs (kubectl, docker, psql, etc.)
- **Analysis tools**: Include ast-grep, semgrep for code agents
- **Security tools**: Add gitleaks, tfsec, syft for security-focused agents

### Agent Design
- **Focused expertise**: Each agent should have a clear, specific domain
- **Comprehensive tooling**: Include all tools needed for the domain
- **Clear descriptions**: Help Claude Code select the right agent
- **Workflow guidance**: Include checklists and best practices

### Performance
- Use **haiku** model for quick, straightforward tasks
- Use **sonnet** (default) for balanced performance
- Use **opus** only for complex, multi-step reasoning tasks

## Integration

### With Claude Code Settings

Add tool permissions to `~/.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(jq:*)",
      "Bash(semgrep:*)",
      "Bash(gitleaks:*)",
      ...
    ]
  }
}
```

### With CLAUDE.md

Add tool usage preferences to `~/.claude/CLAUDE.md`:

```markdown
## Tool Usage Preferences
- Always use jq for JSON parsing
- Run semgrep during code review
- Use gitleaks before commits
```

See the example CLAUDE.md in this repo.

## Examples

### Using the Backend Developer Agent
```
I need to create a REST API for user authentication with JWT tokens
```

### Using the Security Auditor Agent
```
Audit this codebase for security vulnerabilities and compliance issues
```

### Using Multiple Agents
```
Have the backend-developer create the API, then the test-automator
write comprehensive tests, and finally the security-auditor review it
```

## Version History

- **v1.0** (2025-01) - Initial release with 39 agents
- Enhanced all agents with modern tooling (ast-grep, semgrep, jq, etc.)
- Added comprehensive tool suite for security, performance, and quality

## Contributing

Contributions welcome! Please:

1. Follow the existing agent structure
2. Include appropriate tools for the domain
3. Test agents with real-world scenarios
4. Update this README with new agents

## License

MIT License - See [LICENSE](LICENSE) for details

## Resources

- [Claude Code Documentation](https://docs.claude.com/claude-code)
- [Tool Installation Guide](INSTALL-TOOLS.md)
- [Agent Development Guide](AGENT-GUIDE.md)

## Support

For issues or questions:
- Check the troubleshooting section in INSTALL-TOOLS.md
- Review agent-specific documentation in each .md file
- Consult Claude Code official docs

---

**Made with ❤️ for the Claude Code community**
