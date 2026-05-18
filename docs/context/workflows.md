# Workflows

## Onboarding a New Teammate

### Option A — Automated (Recommended)

Run the bootstrap script from the repo root:

**Windows (PowerShell):**
```powershell
.\scripts\bootstrap.ps1
```

**Linux / macOS / Git Bash:**
```bash
bash scripts/bootstrap.sh
```

This symlinks all connector configs and shared skills into `~/.workbuddy/`.

### Option B — Manual

1. Clone the repo:
   ```bash
   git clone https://github.com/YOUR_TEAM/workbuddy-config.git ~/workbuddy-config
   ```
2. Copy skills:
   ```bash
   cp -r ~/workbuddy-config/skills/* ~/.workbuddy/skills/
   ```
3. Copy connector configs:
   ```bash
   cp -r ~/workbuddy-config/connectors/* ~/.workbuddy/connectors-marketplace/connectors/
   ```

## Adding a New Connector

1. Add the connector's MCP config JSON to `connectors/<name>/mcp.json`
2. If the connector has skills, add them to `connectors/<name>/skills/`
3. Document env vars needed in `docs/reference/connector-reference.md`
4. Commit and push

## Adding a New Shared Skill

1. Create or copy the skill folder into `skills/<skill-name>/`
2. Ensure it has a `SKILL.md`
3. Document it in `docs/reference/skill-reference.md`
4. Commit and push

## Updating Credentials for a Credential-Requiring Connector

Credentials are **never** committed to this repo. For connectors that need them:

1. Copy the connector's `mcp.json` to `~/.workbuddy/connectors-marketplace/connectors/<name>/`
2. Replace `${ENV_VAR}` placeholders with your actual credentials
3. Or set the env vars in your shell / environment

## Refreshing From Repo

When the repo updates, pull and rerun bootstrap:

```bash
git pull
.\scripts\bootstrap.ps1   # Windows
bash scripts/bootstrap.sh   # macOS/Linux
```

Existing symlinks are skipped automatically; only new items are linked.
