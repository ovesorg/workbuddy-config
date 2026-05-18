# WorkBuddy Shared Config

Centralized WorkBuddy configuration for team use. Includes connector MCP configs, shared skills, and bootstrap scripts.

## What's Here

```
workbuddy-config/
├── README.md
├── .gitignore
├── mcp.json                     ← Root MCP reference config
├── connectors/                  ← Connector MCP templates (see below)
│   ├── baidu-netdisk/
│   ├── dingtalk/
│   ├── edgeone-pages/
│   ├── fbs-connector/
│   ├── feishu/
│   ├── github/
│   ├── github-remote/
│   ├── gmail/
│   ├── gongfeng-woa/
│   ├── iwiki-woa/
│   ├── jira/
│   ├── kdocs/
│   ├── lexiang/
│   ├── notion/
│   ├── qcc-company/
│   ├── qq-mail/
│   ├── supabase/
│   ├── tapd/
│   ├── tapd-woa/
│   ├── tencent-docs/
│   ├── tencent-survey/
│   ├── tencent-weiyun/
│   └── zhiyan-cicd/
├── skills/                      ← User-installed skills
│   ├── automation-workflows/
│   ├── chatgpt/
│   ├── codex-cli-migration/
│   ├── github/
│   ├── openclaw-odoo/
│   └── web3-graphql/
└── scripts/
    ├── bootstrap.sh             ← Linux/macOS/Git Bash bootstrap
    └── bootstrap.ps1            ← Windows PowerShell bootstrap
```

## Quick Setup (Teammate Onboarding)

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/YOUR_TEAM/workbuddy-config/main/scripts/bootstrap.ps1 | iex
```

### Linux / macOS / Git Bash
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_TEAM/workbuddy-config/main/scripts/bootstrap.sh | bash
```

## Connectors

Connector configs in `connectors/` are **safe to share** — they use environment variable placeholders (e.g. `${JIRA_API_TOKEN}`) for credentials. Each connector's own docs explain how to obtain credentials.

### Connectors Needing Credentials

| Connector | Env Var(s) Required |
|---|---|
| `baidu-netdisk` | `BAIDU_NETDISK_ACCESS_TOKEN` |
| `gmail` | `EMAIL_USER`, `EMAIL_PASSWORD` |
| `jira` | `JIRA_BASE_URL`, `JIRA_USERNAME`, `JIRA_API_TOKEN` |

For these, either set the env vars in your shell before running, or copy the mcp.json to your local `~/.workbuddy/.mcp.json` and replace placeholders.

## Skills

User-installed skills live in `skills/`. These are copied from `~/.workbuddy/skills/`.

To install a skill into your local WorkBuddy:
1. Copy the skill folder into your `~/.workbuddy/skills/`
2. Restart WorkBuddy or reload the skills panel

## MCP Config

The root `mcp.json` is a **reference only** — your local `~/.workbuddy/.mcp.json` may differ as it reflects your active connector proxy. Use it as a template when setting up new connectors.

## License

Internal use only.
