# Capabilities

## What This Repo Provides

### Connector MCP Configs

This repo ships **27 connector MCP templates** — JSON config files for WorkBuddy's MCP server integration. They are located in `connectors/` and are safe to share because they use environment-variable placeholders (e.g. `${JIRA_API_TOKEN}`) instead of real credentials.

Available connectors:

| Connector | Protocol | Env Vars Required |
|---|---|---|
| baidu-netdisk | SSE | `BAIDU_NETDISK_ACCESS_TOKEN` |
| dingtalk | CLI | — |
| edgeone-pages | npx | — |
| fbs-connector | streamable-http | — |
| feishu | CLI | — |
| github | streamable-http | — |
| github-remote | streamable-http | — |
| gmail | stdio | `EMAIL_USER`, `EMAIL_PASSWORD` |
| gongfeng-woa | streamable-http | — |
| iwiki-woa | streamable-http | — |
| jira | stdio | `JIRA_BASE_URL`, `JIRA_USERNAME`, `JIRA_API_TOKEN` |
| kdocs | streamable-http | — |
| lexiang | streamable-http | — |
| notion | streamable-http | — |
| qcc-company | streamable-http | — |
| qq-mail | streamable-http | — |
| supabase | streamable-http | — |
| tapd | streamable-http | — |
| tapd-woa | streamable-http | — |
| tencent-docs | streamable-http | — |
| tencent-survey | streamable-http | — |
| tencent-weiyun | streamable-http | — |
| tmeet | CLI | — |
| wecom | CLI | — |
| zhiyan-cicd | streamable-http | — |

Connectors that require credentials are marked. All others are ready to use with no configuration.

### Shared Skills

Located in `skills/`, these are user-installed skills that your team shares:

- `automation-workflows/` — automation workflow design patterns
- `chatgpt/` — ChatGPT project playbooks and prompt packets
- `codex-cli-migration/` — Codex CLI → WorkBuddy migration guide
- `github/` — GitHub CLI integration
- `openclaw-odoo/` — Odoo ERP connector
- `web3-graphql/` — Web3 / SubGraph data access

### Bootstrap Scripts

- `scripts/bootstrap.sh` — Linux / macOS / Git Bash
- `scripts/bootstrap.ps1` — Windows PowerShell

Both symlink (Windows: junction) connector configs and skills into `~/.workbuddy/`.

### Root MCP Reference

`mcp.json` at the repo root is a reference copy of the MCP server aggregator config. It shows which connectors are currently active via the local connector proxy. It is **not** your live config — copy it to `~/.workbuddy/.mcp.json` and edit as needed.
