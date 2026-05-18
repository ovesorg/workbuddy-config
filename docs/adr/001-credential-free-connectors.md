# ADR-001: Credential-Free Connector Templates

**Status:** Accepted  
**Date:** 2026-05-18  
**Author:** Huashan Wang

## Context

This repo is shared across a team via Git. Real credentials (API tokens, passwords, keys) must not be committed to version control. At the same time, connector MCP configs must be standardized and distributed.

## Decision

All connector MCP configs committed to this repo use `${ENV_VAR}` placeholders instead of real values. Each connector that requires credentials has its env vars documented in `docs/reference/connector-reference.md`.

Team members fill in credentials locally by:
1. Copying the template to `~/.workbuddy/connectors-marketplace/connectors/<name>/`
2. Replacing placeholders, OR
3. Setting env vars in their shell/environment

The `.gitignore` explicitly excludes credential patterns (`*_config.json`, `*secret*`, `*.key`, etc.).

## Consequences

**Positive:**
- Repo can be safely pushed to GitHub
- Credentials are never exposed in history
- Bootstrap is safe to rerun — it never touches local credentials

**Negative:**
- New connectors that require secrets need onboarding documentation
- Each teammate must fill in their own credentials

## Alternatives Considered

1. **Encrypted secrets in repo** — Rejected. Key management overhead; easy to misuse.
2. **Per-user override files (e.g., `mcp.local.json`)** — Considered but `.gitignore` handles this naturally.
3. **Separate private repo for credentials** — Overkill for a small team; adds friction.
