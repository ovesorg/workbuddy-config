# Skill Reference

Shared skills are installed into `~/.workbuddy/skills/` via bootstrap. Each skill has a `SKILL.md` that WorkBuddy reads at startup.

## Available Skills

### automation-workflows

Design and implement automation workflows to save time and scale operations.

**Location:** `skills/automation-workflows/`

### chatgpt

Run ChatGPT with stronger prompts, Projects, memory boundaries, and output QA for research, writing, analysis, and planning.

**Location:** `skills/chatgpt/`

### codex-cli-migration

Complete guide for migrating from Codex CLI to WorkBuddy. Includes command mapping, common patterns, and troubleshooting.

**Location:** `skills/codex-cli-migration/`

### github

Interact with GitHub using the `gh` CLI. Supports issues, PRs, CI runs, and advanced GraphQL queries.

**Location:** `skills/github/`

### openclaw-odoo

Full-featured Odoo 17/18/19 ERP connector for WorkBuddy — Sales, CRM, Inventory, and more.

**Location:** `skills/openclaw-odoo/`

### web3-graphql

Handle Web3 and on-chain questions through GraphQL endpoints (SubQuery / SubGraph). For blockchain metrics, protocol activity, token analysis, and governance queries.

**Location:** `skills/web3-graphql/`

## Skill Metadata

Each skill folder may contain:

| File | Purpose |
|---|---|
| `SKILL.md` | Skill definition — required |
| `_meta.json` | Skill marketplace metadata |
| `_skillhub_meta.json` | SkillHub registry metadata |
| `setup.md` | Setup instructions |
| `requirements.txt` | Python dependencies |
| `scripts/` | Supporting scripts |
| `references/` | Reference docs |
| `assets/` | Static assets |

Skills created by an AI agent have `agent_created: true` in their frontmatter.
