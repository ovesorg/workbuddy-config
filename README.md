# WorkBuddy Shared Config

Centralized WorkBuddy configuration package for team use — connector MCP templates, shared skills, and bootstrap tooling.

> **MCP entry point:** `docs/agent/manifest.yaml` / `docs/agent/start-here.md`
> **分类索引:** `docs/categories/CATEGORIES.md`
> Full documentation surface: `docs/`

## 6 大目标分类

| 分类 | 连接器 | 状态 |
|---|---|---|
| **MS Teams (Azure)** | `ms-teams` | 🆕 新增 |
| **Odoo** | `odoo` | 🆕 新增 |
| **CloudFlare** | `cloudflare`, `edgeone-pages` | 🆕+已有 |
| **Social Platforms** | `wecom`, `dingtalk`, `feishu`, `gongfeng-woa`, `tmeet` | 已有 |
| **OneDrive** | `onedrive` | 🆕 新增 |
| **Documentation Sites** | `notion`, `tencent-docs`, `kdocs`, `lexiang`, `iwiki-woa`, `tapd`, `baidu-netdisk` | 已有 |

完整分类文档：`docs/categories/CATEGORIES.md`

## What Is In This Repo

```
workbuddy-config/
├── docs/                    # Docs surface (agent manifest, reference, ADR, categories)
│   └── categories/          # 6 大目标分类文档
├── connectors/              # 31 connector MCP templates (no credentials)
│   ├── ms-teams/           # 🆕 Microsoft Teams / Azure AD
│   ├── odoo/               # 🆕 Odoo ERP
│   ├── cloudflare/         # 🆕 Cloudflare Workers/R2/D1
│   ├── onedrive/           # 🆕 Microsoft OneDrive
│   └── ...                 # 27 existing connectors
├── skills/                  # 6 shared user skills
├── scripts/                 # Bootstrap tooling
└── mcp.json                 # Root MCP reference (local override, not live config)
```

## For Teammates — Quick Setup

Clone and bootstrap:

```bash
git clone https://github.com/YOUR_TEAM/workbuddy-config.git
cd workbuddy-config
# Windows
.\scripts\bootstrap.ps1
# Linux / macOS / Git Bash
bash scripts/bootstrap.sh
```

Or pipe directly:

```powershell
# Windows
irm https://raw.githubusercontent.com/YOUR_TEAM/workbuddy-config/main/scripts/bootstrap.ps1 | iex
```

```bash
# Linux / macOS / Git Bash
curl -fsSL https://raw.githubusercontent.com/YOUR_TEAM/workbuddy-config/main/scripts/bootstrap.sh | bash
```

Restart WorkBuddy after bootstrap.

## Connectors Needing Credentials

Three connectors require env vars. Documented in full at `docs/reference/connector-reference.md`:

| Connector | Env Vars |
|---|---|
| baidu-netdisk | `BAIDU_NETDISK_ACCESS_TOKEN` |
| gmail | `EMAIL_USER`, `EMAIL_PASSWORD` |
| jira | `JIRA_BASE_URL`, `JIRA_USERNAME`, `JIRA_API_TOKEN` |

All other connectors are template-only and work after bootstrap with no extra config.

## Security Rule

Credentials are never committed here. See `docs/context/contracts.md` for the full list of what is excluded from version control.

## Docs Surface

| Doc | Purpose |
|---|---|
| `docs/agent/start-here.md` | MCP agent orientation |
| `docs/context/capabilities.md` | What this repo provides |
| `docs/context/workflows.md` | Onboarding, adding connectors/skills |
| `docs/context/contracts.md` | What goes in / never goes in this repo |
| `docs/reference/` | Connector env vars, skill reference |
| `docs/adr/` | Architecture decisions |

## Internal use only.
