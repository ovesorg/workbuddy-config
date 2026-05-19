# Capabilities

## What This Repo Provides

### Connector MCP Configs

This repo ships **32 connector MCP templates** — JSON config files for WorkBuddy's MCP server integration. They are located in `connectors/` and are safe to share because they use environment-variable placeholders (e.g. `${JIRA_API_TOKEN}`) instead of real credentials.

### Core Platform Connectors

| Connector | Protocol | Env Vars Required | Purpose |
|---|---|---|---|
| github | streamable-http | — | GitHub API access |
| github-remote | streamable-http | — | Remote GitHub operations |
| **workspace-mcp** | stdio | `WORKSPACE_ROOT=D:\github` | WorkBuddy workspace discovery |
| cloudflare | npx | `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID` | Cloudflare Workers/R2/Pages/D1 |

### Target Category Connectors

| Connector | Category | Env Vars Required |
|---|---|---|
| ms-teams | MS Teams (Azure) | `MS_TENANT_ID`, `MS_CLIENT_ID`, `MS_CLIENT_SECRET` |
| odoo | Odoo ERP | `ODOO_URL`, `ODOO_DB`, `ODOO_USERNAME`, `ODOO_API_KEY` |
| onedrive | OneDrive | `ONEDRIVE_CLIENT_ID`, `ONEDRIVE_CLIENT_SECRET` |
| notion | Documentation | `NOTION_API_TOKEN` |
| tencent-docs | Documentation | — |
| kdocs | Documentation | — |

### Social & Messaging Connectors

| Connector | Protocol | Env Vars Required |
|---|---|---|
| dingtalk | CLI | — |
| feishu | CLI | — |
| wecom | CLI | — |
| tmeet | CLI | — |
| gmail | stdio | `EMAIL_USER`, `EMAIL_PASSWORD` |
| qq-mail | streamable-http | — |
| netease-mail | streamable-http | — |

### Enterprise & Dev Tools

| Connector | Env Vars Required |
|---|---|
| jira | `JIRA_BASE_URL`, `JIRA_USERNAME`, `JIRA_API_TOKEN` |
| tapd | — |
| tapd-woa | — |
| supabase | — |
| zhiyan-cicd | — |

### Template-Only Connectors

These connectors use no env vars and are ready to use after bootstrap:

- baidu-netdisk, ctrip-wendao, edgeone-pages, fbs-connector, gongfeng-woa, iwiki-woa, kdocs, lexiang, qcc-company, qq-mail, tencent-survey, tencent-weiyun

### Shared Skills

Located in `skills/`, these are user-installed skills that your team shares:

- `automation-workflows/` — automation workflow design patterns
- `chatgpt/` — ChatGPT project playbooks and prompt packets
- `codex-cli-migration/` — Codex CLI → WorkBuddy migration guide
- `doc-site-template/` — mkdocs-template doc-site lifecycle (migrate → normalize → KRR)
- `github/` — GitHub CLI integration
- `openclaw-odoo/` — Odoo ERP connector
- `web3-graphql/` — Web3 / SubGraph data access

### Bootstrap Scripts

- `scripts/bootstrap.sh` — Linux / macOS / Git Bash
- `scripts/bootstrap.ps1` — Windows PowerShell

Both symlink (Windows: junction) connector configs and skills into `~/.workbuddy/`.

### Root MCP Reference

`mcp.json` at the repo root is a reference copy of the MCP server aggregator config. It shows which connectors are currently active via the local connector proxy. It is **not** your live config — copy it to `~/.workbuddy/.mcp.json` and edit as needed.

## AI Agent快速入门

### 通过 workspace-mcp 发现本仓库

当 WorkBuddy 通过 `workspace-mcp` 连接到 `D:\github` 工作区时：

1. 工作区 registry 自动索引 `workbuddy-config` 的 manifest（`docs/agent/manifest.yaml`）
2. Agent 读取 `authority_order` 了解本仓库的决策优先级
3. Agent 从 `entrypoints` 列表读取入口文档

### 读取 manifest

```
GET docs/agent/manifest.yaml
→ resource_roots.connectors = "connectors"
→ resource_roots.skills = "skills"
→ components[0].paths.configs = "connectors"
```

### 快速找到 connector 配置

```
connectors/{name}/mcp.json       ← MCP server 连接配置
connectors/{name}/SKILL.md       ← connector 能力描述
docs/reference/connector-reference.md ← 所有 connector 的环境变量参考
```

### credential-free 原则

所有 `mcp.json` 中的敏感字段使用 `${ENV_VAR}` 占位符，不含真实凭证。

| 字段 | 说明 |
|---|---|
| `${CLOUDFLARE_API_TOKEN}` | Cloudflare API Token |
| `${CLOUDFLARE_ACCOUNT_ID}` | Cloudflare Account ID |
| `${JIRA_API_TOKEN}` | Atlassian API Token |
| `${NOTION_API_TOKEN}` | Notion Integration Token |
| `${ODOO_API_KEY}` | Odoo API Key |
